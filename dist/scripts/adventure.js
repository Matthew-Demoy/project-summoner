"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const ethers_1 = __importDefault(require("ethers"));
const rarity_1 = require("../addresses/rarity");
const typechain_1 = require("../typechain");
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const main = async () => {
    if (PRIVATE_KEY === undefined) {
        console.debug("PRIVATE_KEY is undefined");
        return;
    }
    const wallet = new ethers_1.default.Wallet(PRIVATE_KEY);
    const raribleContract = typechain_1.Rarity__factory.connect(rarity_1.rarity.rarity, wallet);
    const balance = raribleContract.balanceOf(wallet.address);
    //raribleContract.adventure()
    console.log(balance);
};
main();
