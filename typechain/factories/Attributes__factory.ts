/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { Attributes, AttributesInterface } from "../Attributes";

const _abi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "ability_scores",
    outputs: [
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "character_created",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

export class Attributes__factory {
  static readonly abi = _abi;
  static createInterface(): AttributesInterface {
    return new utils.Interface(_abi) as AttributesInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): Attributes {
    return new Contract(address, _abi, signerOrProvider) as Attributes;
  }
}
