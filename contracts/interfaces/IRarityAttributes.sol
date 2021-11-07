pragma solidity ^0.8.7;

interface IRarityAttributes {
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