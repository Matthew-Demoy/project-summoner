"use strict";
/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
exports.__esModule = true;
exports.CodexBaseRandom__factory = void 0;
var ethers_1 = require("ethers");
var _abi = [
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_summoner",
                type: "uint256"
            },
        ],
        name: "d20",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            },
        ],
        stateMutability: "view",
        type: "function"
    },
];
var CodexBaseRandom__factory = /** @class */ (function () {
    function CodexBaseRandom__factory() {
    }
    CodexBaseRandom__factory.createInterface = function () {
        return new ethers_1.utils.Interface(_abi);
    };
    CodexBaseRandom__factory.connect = function (address, signerOrProvider) {
        return new ethers_1.Contract(address, _abi, signerOrProvider);
    };
    CodexBaseRandom__factory.abi = _abi;
    return CodexBaseRandom__factory;
}());
exports.CodexBaseRandom__factory = CodexBaseRandom__factory;
