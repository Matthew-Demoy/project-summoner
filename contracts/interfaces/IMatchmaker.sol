pragma solidity ^0.8.7;

interface IMatchmaker {
    struct Match {
        uint256[] teamOne;
        uint256[] teamTwo;
        //uint256 bestOf;
        uint8 mapId;
        uint256 matchStart;
    }

    event rollInitiativeEvent(uint256[8] initiatives);

    function _createGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        uint8 mapId
    ) external returns (bytes32 gameId);

    function _startGame(
        uint256[] memory teamOne,
        uint256[] memory teamTwo,
        bytes32 gameId
    ) external;
}
