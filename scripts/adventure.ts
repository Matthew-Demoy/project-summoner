import { rarity } from "../addresses/rarity";
import { rarity as rarityABI } from "../abis/rarity";
import { ERC721Enumerable__factory, Rarity__factory } from "../typechain";
import hre from "hardhat";
const ethers = hre.ethers;
import dotenv from "dotenv";
import Web3 from "web3";
dotenv.config({ path: "../.env" });
const { NonceManager } = require("@ethersproject/experimental");

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const abi = [
  {
    inputs: [],
    name: "totalSupply",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "approved",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
    ],
    name: "ApprovalForAll",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "level",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "summoner",
        type: "uint256",
      },
    ],
    name: "leveled",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "class",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "summoner",
        type: "uint256",
      },
    ],
    name: "summoned",
    type: "event",
  },
  {
    inputs: [{ internalType: "uint256", name: "_summoner", type: "uint256" }],
    name: "adventure",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    name: "adventurers_log",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "to", type: "address" },
      { internalType: "uint256", name: "tokenId", type: "uint256" },
    ],
    name: "approve",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "owner", type: "address" }],
    name: "balanceOf",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    name: "class",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "id", type: "uint256" }],
    name: "classes",
    outputs: [{ internalType: "string", name: "description", type: "string" }],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "tokenId", type: "uint256" }],
    name: "getApproved",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "owner", type: "address" },
      { internalType: "address", name: "operator", type: "address" },
    ],
    name: "isApprovedForAll",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    name: "level",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_summoner", type: "uint256" }],
    name: "level_up",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "next_summoner",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "tokenId", type: "uint256" }],
    name: "ownerOf",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
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
    type: "function",
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
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "operator", type: "address" },
      { internalType: "bool", name: "approved", type: "bool" },
    ],
    name: "setApprovalForAll",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "uint256", name: "_summoner", type: "uint256" },
      { internalType: "uint256", name: "_xp", type: "uint256" },
    ],
    name: "spend_xp",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_class", type: "uint256" }],
    name: "summon",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
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
    type: "function",
  },
  {
    inputs: [],
    name: "symbol",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "_summoner", type: "uint256" }],
    name: "tokenURI",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
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
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    name: "xp",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
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
        type: "uint256",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
];

async function main3() {
  const web3 = new Web3("https://rpc.ftm.tools");
  web3.eth.handleRevert = true;
  //@ts-ignore
  const contract = new web3.eth.Contract(abi, rarity.rarity);
  const totalSupply = await contract.methods.totalSupply().call();
  console.log(totalSupply);
}
async function main2() {
  if (PRIVATE_KEY === undefined) {
    console.debug("PRIVATE_KEY is undefined");
    return;
  }
  const provider = new ethers.providers.JsonRpcProvider(
    "https://rpc.ftm.tools",
    {
      name: "Fantom Opera",
      chainId: 250,
    }
  );

  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  const raribleContract = new ethers.Contract(rarity.rarity, rarityABI, wallet);

  const totalSupply = await raribleContract.totalSupply();
  console.log(totalSupply);
}
async function main() {
  if (PRIVATE_KEY === undefined) {
    console.debug("PRIVATE_KEY is undefined");
    return;
  }
  const provider = new ethers.providers.JsonRpcProvider(
    "https://rpc.ftm.tools",
    250
  );

  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  const contract = new ethers.Contract(rarity.rarity, abi, provider);
  const nonceManager = new NonceManager(wallet);
  const raribleContract = contract.connect(nonceManager);

  const totalSupply = await raribleContract.totalSupply();
  console.log(totalSupply);
  const balance = await raribleContract.balanceOf(wallet.address);

  const balanceBN = ethers.BigNumber.from(balance);
  let summonerIndex = 1;
  while (summonerIndex < balanceBN.toNumber()) {
    const summonerID = await raribleContract.tokenOfOwnerByIndex(
      wallet.address,
      summonerIndex
    );
    console.log(summonerID.toString());

    //const summoner = await raribleContract.summoner(summonerID);
    //console.log(summoner._class);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
