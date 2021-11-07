pragma solidity ^0.8.7;

interface ICodexBaseRandom {
    function d20(uint256 _summoner) external view returns (uint256);
}