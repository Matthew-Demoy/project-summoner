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

        matches[gameId] = Match(teamOne, teamTwo, mapId);
        return gameId;
    }

    function rollInitiative(uint256[] memory teamOne, uint256[] memory teamTwo)
        private
    {
        uint256 dex;
        uint8[35] memory initiativeCounts = [
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0
        ];
        uint8[8] memory initiatives = [0, 0, 0, 0, 0, 0, 0, 0];
        uint256 initiative;
        for (uint256 i = 0; i < teamOne.length; i++) {
            (, dex, , , , ) = rmAttributes.ability_scores(teamOne[i]);
            initiative = rmAttributes.calc(dex) + _random.d20(teamOne[i]) + 5;
            initiativeCounts[initiative]++;
            //initiatives[i] = initiative;

            (, dex, , , , ) = rmAttributes.ability_scores(teamTwo[i]);
            initiativeCounts[
                rmAttributes.calc(dex) + _random.d20(teamTwo[i]) + 5
            ]++;
        }

        uint256[] memory summonerIdsOrderedByInitiative;
        for (uint256 i = 0; i < summonerIdsOrderedByInitiative.length; i++) {
            cooldowns[summonerIdsOrderedByInitiative[i]] =
                block.timestamp +
                30 +
                30 *
                i;
        }
    }

    function _startGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        bytes32 gameId
    ) external {
        require(teamOne.length > 0 && teamOne.length == teamTwo.length);
        require(gameId == keccak256(abi.encodePacked(teamOne, teamTwo)));
        for (uint256 i = 0; i < teamTwo.length; i++) {
            require(rm.ownerOf(teamTwo[i]) == msg.sender);
            require(cooldowns[teamTwo[i]] == 0 && cooldowns[teamOne[i]] == 0);
            cooldowns[teamOne[i]] = block.timestamp + turn;
            cooldowns[teamTwo[i]] = block.timestamp + turn;
        }
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
    tile[][] board;

    mapping(uint256 => position) private summonerPositions;

    event createGameEvent(
        address sender,
        bytes32 gameId,
        uint256[] teamOne,
        uint256[] teamTwo
    );

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
            board[desiredPosition.x][desiredPosition.y].tileType ==
                TileType.NORMAL ||
                board[desiredPosition.x][desiredPosition.y].tileType ==
                TileType.START
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

    function setStartingPosition(
        uint256 x,
        uint256 y,
        uint256 summonerId
    ) public {
        require(board.length < x && x >= 0);
        require(board[0].length < y && y >= 0);
        require(board[x][y].tileType == TileType.START);
        summonerPositions[summonerId] = position(x, y);
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
    ) external returns (bytes32 ) {
        bytes32 res = _createGame(teamOne, teamTwo, mapId);
        emit createGameEvent(msg.sender, res, teamOne, teamTwo);
        return res;
    }
}
