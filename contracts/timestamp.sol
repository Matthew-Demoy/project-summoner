pragma solidity ^0.8.7;

contract timestamp {
    function getTimestamp() view public returns (uint)  {
        return block.timestamp;
    }
}