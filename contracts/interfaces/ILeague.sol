pragma solidity ^0.8.6;

interface ILeague {

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

    event createGameEvent(address indexed sender, bytes32 indexed gameId);

    event startGameEvent(
        address indexed sender,
        bytes32 indexed gameId,
        uint256 startTime
    );

    function getSummonerPosition(uint256 summonerId)
        external
        view
        returns (position memory);

    function startGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        bytes32 gameId
    ) external;

    function createGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        uint8 mapId
    ) external returns (bytes32);

     function takeAction(
        uint256 summonerId,
        position[] calldata preMoves,
        uint256 action,
        position[] calldata postMoves
    ) external;
}
