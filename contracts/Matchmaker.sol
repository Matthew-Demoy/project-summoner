pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "./interfaces/ICodexRandom.sol";
import "./interfaces/IRarityAttributes.sol";
import "./interfaces/IRarity.sol";
import "./interfaces/IMatchmaker.sol";

contract Matchmaker is IMatchmaker {
    mapping(bytes32 => Match) public matches;
    mapping(uint256 => uint256) public cooldowns;

    uint256 constant turn = 30 seconds;

    IRarity public rm = IRarity(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);
    IRarityAttributes public rmAttributes =
        IRarityAttributes(0xB5F5AF1087A8DA62A23b08C00C6ec9af21F397a1);
    ICodexBaseRandom public _random =
        ICodexBaseRandom(0x7426dBE5207C2b5DaC57d8e55F0959fcD99661D4);

    constructor(
        address rarityAddress,
        address rarityAttrAddress,
        address codexBaseRandomAddress
    ) {
        rm = IRarity(rarityAddress);
        rmAttributes = IRarityAttributes(rarityAttrAddress);
        _random = ICodexBaseRandom(codexBaseRandomAddress);
    }

    function _createGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        uint8 mapId
    ) external override returns (bytes32 gameId) {
        require(teamOne.length > 0 && teamOne.length == teamTwo.length);
        for (uint256 i = 0; i < teamOne.length; i++) {
            require(rm.ownerOf(teamOne[i]) == msg.sender);
            require(cooldowns[teamOne[i]] == 0);
        }
        gameId = keccak256(abi.encodePacked(teamOne, teamTwo));

        matches[gameId] = Match(teamOne, teamTwo, mapId, 0);
        return gameId;
    }

    function _startGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        bytes32 gameId
    ) external override {
        require(teamOne.length > 0 && teamOne.length == teamTwo.length);
        require(gameId == keccak256(abi.encodePacked(teamOne, teamTwo)));
        for (uint256 i = 0; i < teamTwo.length - 1; i++) {
            require(rm.ownerOf(teamTwo[i]) == msg.sender);
            require(cooldowns[teamTwo[i]] == 0 && cooldowns[teamOne[i]] == 0);
        }
        rollInitiative(teamOne, teamTwo);
        matches[gameId].matchStart = block.timestamp + 30;
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
                if (j < teamOne.length) {
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
}
