pragma solidity ^0.8.7;

import "hardhat/console.sol";

interface rarity {
    function level(uint256) external view returns (uint256);

    function class(uint256) external view returns (uint256);

    function getApproved(uint256) external view returns (address);

    function ownerOf(uint256) external view returns (address);

    function summoner(uint256 _summoner)
        external
        view
        returns (
            uint256 _xp,
            uint256 _log,
            uint256 _class,
            uint256 _level
        );
}

interface rarityAttributes {
    function ability_scores(uint256)
        external
        view
        returns (
            uint32,
            uint32,
            uint32,
            uint32,
            uint32,
            uint32
        );

    function calc(uint256 score) external pure returns (uint256);
}

interface codex_base_random {
    function d20(uint256 _summoner) external view returns (uint256);
}

contract MatchMaker {
    struct Match {
        uint256[] teamOne;
        uint256[] teamTwo;
        //uint256 bestOf;
        uint8 mapId;
        uint256 matchStart;
    }

    mapping(bytes32 => Match) public matches;
    mapping(uint256 => uint256) public cooldowns;

    uint256 constant turn = 30 seconds;

    rarity public rm = rarity(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);
    rarityAttributes public rmAttributes =
        rarityAttributes(0xB5F5AF1087A8DA62A23b08C00C6ec9af21F397a1);
    codex_base_random public _random =
        codex_base_random(0x7426dBE5207C2b5DaC57d8e55F0959fcD99661D4);

    constructor(
        address rarityAddress,
        address rarityAttrAddress,
        address codexBaseRandomAddress
    ) {
        rm = rarity(rarityAddress);
        rmAttributes = rarityAttributes(rarityAttrAddress);
        _random = codex_base_random(codexBaseRandomAddress);
    }

    event rollInitiativeEvent(uint256[8] initiatives);

    function _createGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        uint8 mapId
    ) public returns (bytes32 gameId) {
        require(teamOne.length > 0 && teamOne.length == teamTwo.length);
        for (uint256 i = 0; i < teamOne.length; i++) {
            require(rm.ownerOf(teamOne[i]) == msg.sender);
            require(cooldowns[teamOne[i]] == 0);
        }
        gameId = keccak256(abi.encodePacked(teamOne, teamTwo));

        matches[gameId] = Match(teamOne, teamTwo, mapId, 0);
        return gameId;
    }

    function rollInitiative(uint256[] memory teamOne, uint256[] memory teamTwo)
        private
    {
        uint256 dex;
        uint256[8] memory initiatives;
        uint256 initiative;
        uint256 initiativeCount;
        for (uint256 i = 0; i < teamOne.length; i++) {
            (, dex, , , , ) = rmAttributes.ability_scores(teamOne[i]);
            initiative = rmAttributes.calc(dex) + _random.d20(teamOne[i]) + 5;
            console.log("initiative is %s", initiative);
            uint256 priority = 0;
            for (uint256 j = 0; j < initiativeCount; j++) {
                if (initiatives[j] < initiative) {
                    cooldowns[teamOne[j]] = cooldowns[teamOne[j]] + 30;
                } else {
                    priority++;
                }
            }

            cooldowns[teamOne[i]] = block.timestamp + 30 + 30 * priority;

            initiatives[initiativeCount] = initiative;
            initiativeCount++;
        }

        for (uint256 i = 0; i < teamTwo.length; i++) {
            (, dex, , , , ) = rmAttributes.ability_scores(teamTwo[i]);
            initiative = rmAttributes.calc(dex) + _random.d20(teamTwo[i]) + 5;
            console.log("initiative is %s", initiative);
            uint256 priority = 0;
            for (uint256 j = 0; j < initiativeCount; j++) {
                if (j <= teamOne.length) {
                    if (initiatives[j] < initiative) {
                        cooldowns[teamOne[j]] = cooldowns[teamOne[j]] + 30;
                    } else {
                        priority++;
                    }
                } else {
                    if (initiatives[j] < initiative) {
                        cooldowns[teamTwo[j / 2]] =
                            cooldowns[teamTwo[j / 2]] +
                            30;
                    } else {
                        priority++;
                    }
                }
            }

            cooldowns[teamTwo[i]] = block.timestamp + 30 + 30 * priority;

            initiatives[initiativeCount] = initiative;
            initiativeCount++;
        }
        emit rollInitiativeEvent(initiatives);
    }

    function _startGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        bytes32 gameId
    ) public {
        require(teamOne.length > 0 && teamOne.length == teamTwo.length);
        require(gameId == keccak256(abi.encodePacked(teamOne, teamTwo)));
        for (uint256 i = 0; i < teamTwo.length - 1; i++) {
            require(rm.ownerOf(teamTwo[i]) == msg.sender);
            require(cooldowns[teamTwo[i]] == 0 && cooldowns[teamOne[i]] == 0);
        }
        rollInitiative(teamOne, teamTwo);
        matches[gameId].matchStart = block.timestamp + 30;
    }
}

contract League is MatchMaker {
    mapping(uint256 => uint256) private wins;
    mapping(uint256 => uint256) private losses;
    mapping(uint256 => uint256) private ties;
    uint256 teamSize;
    uint256 levelCap;
    uint256 combinedLevelCap;
    string leagueName;
    //uint bannedClasses
    //uint bannedItems
    //uint bannedFeats

    mapping(uint256 => bytes32) summonersToGameId;
    mapping(bytes32 => uint256[]) gameIdToPlayers;

    constructor(
        address rarityAddress,
        address rarityAttrAddress,
        address codexBaseRandomAddress
    ) MatchMaker(rarityAddress, rarityAttrAddress, codexBaseRandomAddress) {}

    enum TileType {
        NORMAL,
        START,
        WALL
    }

    struct tile {
        TileType tileType;
    }
    struct position {
        uint256 x;
        uint256 y;
    }

    struct action {
        uint256 target;
        uint256 actionType;
    }

    TileType[32][32] board = [
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.START,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.START,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.START,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.START,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.START,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.START,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.START,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.START,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.NORMAL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ],
        [
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL,
            TileType.WALL
        ]
    ];

    mapping(uint256 => position) private summonerPositions;

    event createGameEvent(
        address sender,
        bytes32 gameId,
        uint256[] teamOne,
        uint256[] teamTwo
    );

    event startGameEvent(address sender, bytes32 gameId, uint256 startTime);

    modifier validMove(
        position storage currentPosition,
        position calldata desiredPosition
    ) {
        require(
            currentPosition.x <= desiredPosition.x &&
                currentPosition.x >= desiredPosition.x
        );
        require(
            currentPosition.y <= desiredPosition.y &&
                currentPosition.y >= desiredPosition.y
        );
        require(
            board[desiredPosition.x][desiredPosition.y] == TileType.NORMAL ||
                board[desiredPosition.x][desiredPosition.y] == TileType.START
        );
        require(
            desiredPosition.x <= board.length &&
                desiredPosition.y <= board[0].length
        );
        _;
    }

    modifier validLastMove(
        uint256 summonerId,
        position calldata desiredPosition,
        bool isLastMove
    ) {
        if (!isLastMove) {
            _;
        }
        uint256[] storage players = gameIdToPlayers[
            summonersToGameId[summonerId]
        ];
        for (uint256 i = 0; i < players.length; i++) {
            require(
                summonerPositions[players[i]].x != desiredPosition.x &&
                    summonerPositions[players[i]].y != desiredPosition.y
            );
        }
        _;
    }

    modifier offCooldown(uint256 summonerId) {
        require(cooldowns[summonerId] <= block.timestamp);
        _;
    }

    function evaluateMove(
        uint256 summonerId,
        position storage currentPosition,
        position calldata desiredPosition,
        bool isLastMove
    )
        private
        validMove(currentPosition, desiredPosition)
        validLastMove(summonerId, desiredPosition, isLastMove)
    {
        summonerPositions[summonerId] = desiredPosition;
    }

    function calculateSpeed(uint256 summonerId) private view returns (uint256) {
        (, , uint256 class, ) = rm.summoner(summonerId);
        if (class == 1) {
            return 40;
        }

        return 30;
    }

    function takeAction(
        uint256 summonerId,
        position[] calldata preMoves,
        uint256 action,
        position[] calldata postMoves
    ) public offCooldown(summonerId) {
        //track speed, not let ending move be on another char
        uint256 speed = calculateSpeed(summonerId);

        require(rm.ownerOf(summonerId) == msg.sender);
        for (uint256 i = 0; i < preMoves.length; i++) {
            if (speed <= 0) {
                break;
            }
            if (preMoves.length == i) {
                evaluateMove(
                    summonerId,
                    summonerPositions[summonerId],
                    preMoves[i],
                    true
                );
            } else {
                evaluateMove(
                    summonerId,
                    summonerPositions[summonerId],
                    preMoves[i],
                    false
                );
            }
            speed = speed - 5;
        }

        for (uint256 i = 0; i < postMoves.length; i++) {
            if (speed <= 0) {
                break;
            }
            if (preMoves.length == i) {
                evaluateMove(
                    summonerId,
                    summonerPositions[summonerId],
                    postMoves[i],
                    true
                );
            } else {
                evaluateMove(
                    summonerId,
                    summonerPositions[summonerId],
                    postMoves[i],
                    true
                );
            }
            speed = speed - 5;
        }
    }

    function createGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        uint8 mapId
    ) external returns (bytes32) {
        bytes32 res = _createGame(teamOne, teamTwo, mapId);
        emit createGameEvent(msg.sender, res, teamOne, teamTwo);
        return res;
    }

    function startGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        bytes32 gameId
    ) public {
        _startGame(teamOne, teamTwo, gameId);
        for (uint256 i = 0; i < teamOne.length; i++) {
            if (i % 4 == 0) {
                summonerPositions[teamOne[i]] = position(14, 11);
                summonerPositions[teamTwo[i]] = position(14, 21);
            }
            if (i % 4 == 1) {
                summonerPositions[teamOne[i]] = position(16, 11);
                summonerPositions[teamTwo[i]] = position(16, 21);
            }
            if (i % 4 == 2) {
                summonerPositions[teamOne[i]] = position(16, 8);
                summonerPositions[teamTwo[i]] = position(16, 24);
            }
            if (i % 4 == 3) {
                summonerPositions[teamOne[i]] = position(14, 8);
                summonerPositions[teamTwo[i]] = position(14, 24);
            }
        }
        emit startGameEvent(msg.sender, gameId, block.timestamp);
    }
}
