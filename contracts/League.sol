pragma solidity ^0.8.7;

import "./Matchmaker.sol";
import "./interfaces/ILeague.sol";

contract League is Matchmaker, ILeague {
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
    ) Matchmaker(rarityAddress, rarityAttrAddress, codexBaseRandomAddress) {}

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

    mapping(uint256 => position) public summonerPositions;

    modifier validMove(
        position storage currentPosition,
        position calldata desiredPosition
    ) {
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

    function takeAction(
        uint256 summonerId,
        position[] calldata preMoves,
        uint256 action,
        position[] calldata postMoves
    ) external override offCooldown(summonerId) {
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
    ) external override returns (bytes32) {
        bytes32 res = this._createGame(teamOne, teamTwo, mapId);
        emit createGameEvent(msg.sender, res);
        return res;
    }

    function startGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        bytes32 gameId
    ) external override {
        this._startGame(teamOne, teamTwo, gameId);
        for (uint256 i = 0; i < teamOne.length; i++) {
            if (i % 4 == 0) {
                summonerPositions[teamOne[i]] = position(11, 14);
                summonerPositions[teamTwo[i]] = position(21, 14);
            }
            if (i % 4 == 1) {
                summonerPositions[teamOne[i]] = position(11, 16);
                summonerPositions[teamTwo[i]] = position(21, 16);
            }
            if (i % 4 == 2) {
                summonerPositions[teamOne[i]] = position(8, 16);
                summonerPositions[teamTwo[i]] = position(24, 16);
            }
            if (i % 4 == 3) {
                summonerPositions[teamOne[i]] = position(8, 14);
                summonerPositions[teamTwo[i]] = position(24, 14);
            }
        }
        emit startGameEvent(msg.sender, gameId, block.timestamp);
    }

    function getSummonerPosition(uint256 summonerId)
        public
        view
        override
        returns (position memory)
    {
        return summonerPositions[summonerId];
    }

    function calculateSpeed(uint256 summonerId) private view returns (uint256) {
        (, , uint256 class, ) = rm.summoner(summonerId);
        if (class == 1) {
            return 40;
        }

        return 30;
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
}