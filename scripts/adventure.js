"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
exports.__esModule = true;
var rarity_1 = require("../addresses/rarity");
var rarity_2 = require("../abis/rarity");
var hardhat_1 = require("hardhat");
var ethers = hardhat_1["default"].ethers;
var dotenv_1 = require("dotenv");
var web3_1 = require("web3");
dotenv_1["default"].config({ path: "../.env" });
var NonceManager = require("@ethersproject/experimental").NonceManager;
var PRIVATE_KEY = process.env.PRIVATE_KEY;
var abi = [
    {
        inputs: [],
        name: "totalSupply",
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
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "owner",
                type: "address"
            },
            {
                indexed: true,
                internalType: "address",
                name: "approved",
                type: "address"
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "tokenId",
                type: "uint256"
            },
        ],
        name: "Approval",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "owner",
                type: "address"
            },
            {
                indexed: true,
                internalType: "address",
                name: "operator",
                type: "address"
            },
            {
                indexed: false,
                internalType: "bool",
                name: "approved",
                type: "bool"
            },
        ],
        name: "ApprovalForAll",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "from",
                type: "address"
            },
            {
                indexed: true,
                internalType: "address",
                name: "to",
                type: "address"
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "tokenId",
                type: "uint256"
            },
        ],
        name: "Transfer",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "owner",
                type: "address"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "level",
                type: "uint256"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "summoner",
                type: "uint256"
            },
        ],
        name: "leveled",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "owner",
                type: "address"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "class",
                type: "uint256"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "summoner",
                type: "uint256"
            },
        ],
        name: "summoned",
        type: "event"
    },
    {
        inputs: [{ internalType: "uint256", name: "_summoner", type: "uint256" }],
        name: "adventure",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        name: "adventurers_log",
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            { internalType: "address", name: "to", type: "address" },
            { internalType: "uint256", name: "tokenId", type: "uint256" },
        ],
        name: "approve",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [{ internalType: "address", name: "owner", type: "address" }],
        name: "balanceOf",
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        name: "class",
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "id", type: "uint256" }],
        name: "classes",
        outputs: [{ internalType: "string", name: "description", type: "string" }],
        stateMutability: "pure",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "tokenId", type: "uint256" }],
        name: "getApproved",
        outputs: [{ internalType: "address", name: "", type: "address" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            { internalType: "address", name: "owner", type: "address" },
            { internalType: "address", name: "operator", type: "address" },
        ],
        name: "isApprovedForAll",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        name: "level",
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "_summoner", type: "uint256" }],
        name: "level_up",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [],
        name: "name",
        outputs: [{ internalType: "string", name: "", type: "string" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "next_summoner",
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "tokenId", type: "uint256" }],
        name: "ownerOf",
        outputs: [{ internalType: "address", name: "", type: "address" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            { internalType: "address", name: "from", type: "address" },
            { internalType: "address", name: "to", type: "address" },
            { internalType: "uint256", name: "tokenId", type: "uint256" },
        ],
        name: "safeTransferFrom",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            { internalType: "address", name: "from", type: "address" },
            { internalType: "address", name: "to", type: "address" },
            { internalType: "uint256", name: "tokenId", type: "uint256" },
            { internalType: "bytes", name: "_data", type: "bytes" },
        ],
        name: "safeTransferFrom",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            { internalType: "address", name: "operator", type: "address" },
            { internalType: "bool", name: "approved", type: "bool" },
        ],
        name: "setApprovalForAll",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            { internalType: "uint256", name: "_summoner", type: "uint256" },
            { internalType: "uint256", name: "_xp", type: "uint256" },
        ],
        name: "spend_xp",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "_class", type: "uint256" }],
        name: "summon",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "_summoner", type: "uint256" }],
        name: "summoner",
        outputs: [
            { internalType: "uint256", name: "_xp", type: "uint256" },
            { internalType: "uint256", name: "_log", type: "uint256" },
            { internalType: "uint256", name: "_class", type: "uint256" },
            { internalType: "uint256", name: "_level", type: "uint256" },
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "symbol",
        outputs: [{ internalType: "string", name: "", type: "string" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "_summoner", type: "uint256" }],
        name: "tokenURI",
        outputs: [{ internalType: "string", name: "", type: "string" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            { internalType: "address", name: "from", type: "address" },
            { internalType: "address", name: "to", type: "address" },
            { internalType: "uint256", name: "tokenId", type: "uint256" },
        ],
        name: "transferFrom",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        name: "xp",
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            { internalType: "uint256", name: "curent_level", type: "uint256" },
        ],
        name: "xp_required",
        outputs: [
            {
                internalType: "uint256",
                name: "xp_to_next_level",
                type: "uint256"
            },
        ],
        stateMutability: "pure",
        type: "function"
    },
];
function main3() {
    return __awaiter(this, void 0, void 0, function () {
        var web3, contract, totalSupply;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    web3 = new web3_1["default"]("https://rpc.ftm.tools");
                    web3.eth.handleRevert = true;
                    contract = new web3.eth.Contract(abi, rarity_1.rarity.rarity);
                    return [4 /*yield*/, contract.methods.totalSupply().call()];
                case 1:
                    totalSupply = _a.sent();
                    console.log(totalSupply);
                    return [2 /*return*/];
            }
        });
    });
}
function main2() {
    return __awaiter(this, void 0, void 0, function () {
        var provider, wallet, raribleContract, totalSupply;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    if (PRIVATE_KEY === undefined) {
                        console.debug("PRIVATE_KEY is undefined");
                        return [2 /*return*/];
                    }
                    provider = new ethers.providers.JsonRpcProvider("https://rpc.ftm.tools", {
                        name: "Fantom Opera",
                        chainId: 250
                    });
                    wallet = new ethers.Wallet(PRIVATE_KEY, provider);
                    raribleContract = new ethers.Contract(rarity_1.rarity.rarity, rarity_2.rarity, wallet);
                    return [4 /*yield*/, raribleContract.totalSupply()];
                case 1:
                    totalSupply = _a.sent();
                    console.log(totalSupply);
                    return [2 /*return*/];
            }
        });
    });
}
function main() {
    return __awaiter(this, void 0, void 0, function () {
        var provider, wallet, contract, nonceManager, raribleContract, totalSupply, balance, balanceBN, summonerIndex, summonerID;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    if (PRIVATE_KEY === undefined) {
                        console.debug("PRIVATE_KEY is undefined");
                        return [2 /*return*/];
                    }
                    provider = new ethers.providers.JsonRpcProvider("https://rpc.ftm.tools", 250);
                    wallet = new ethers.Wallet(PRIVATE_KEY, provider);
                    contract = new ethers.Contract(rarity_1.rarity.rarity, abi, provider);
                    nonceManager = new NonceManager(wallet);
                    raribleContract = contract.connect(nonceManager);
                    return [4 /*yield*/, raribleContract.totalSupply()];
                case 1:
                    totalSupply = _a.sent();
                    console.log(totalSupply);
                    return [4 /*yield*/, raribleContract.balanceOf(wallet.address)];
                case 2:
                    balance = _a.sent();
                    balanceBN = ethers.BigNumber.from(balance);
                    summonerIndex = 1;
                    _a.label = 3;
                case 3:
                    if (!(summonerIndex < balanceBN.toNumber())) return [3 /*break*/, 5];
                    return [4 /*yield*/, raribleContract.tokenOfOwnerByIndex(wallet.address, summonerIndex)];
                case 4:
                    summonerID = _a.sent();
                    console.log(summonerID.toString());
                    return [3 /*break*/, 3];
                case 5: return [2 /*return*/];
            }
        });
    });
}
main()
    .then(function () { return process.exit(0); })["catch"](function (error) {
    console.error(error);
    process.exit(1);
});
