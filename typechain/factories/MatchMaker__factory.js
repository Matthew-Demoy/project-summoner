"use strict";
/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        if (typeof b !== "function" && b !== null)
            throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
exports.__esModule = true;
exports.MatchMaker__factory = void 0;
var ethers_1 = require("ethers");
var _abi = [
    {
        inputs: [
            {
                internalType: "address",
                name: "rarityAddress",
                type: "address"
            },
            {
                internalType: "address",
                name: "rarityAttrAddress",
                type: "address"
            },
            {
                internalType: "address",
                name: "codexBaseRandomAddress",
                type: "address"
            },
        ],
        stateMutability: "nonpayable",
        type: "constructor"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "uint256[8]",
                name: "initiatives",
                type: "uint256[8]"
            },
        ],
        name: "rollInitiativeEvent",
        type: "event"
    },
    {
        inputs: [
            {
                internalType: "uint256[]",
                name: "teamOne",
                type: "uint256[]"
            },
            {
                internalType: "uint256[]",
                name: "teamTwo",
                type: "uint256[]"
            },
            {
                internalType: "uint8",
                name: "mapId",
                type: "uint8"
            },
        ],
        name: "_createGame",
        outputs: [
            {
                internalType: "bytes32",
                name: "gameId",
                type: "bytes32"
            },
        ],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [],
        name: "_random",
        outputs: [
            {
                internalType: "contract codex_base_random",
                name: "",
                type: "address"
            },
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256[]",
                name: "teamOne",
                type: "uint256[]"
            },
            {
                internalType: "uint256[]",
                name: "teamTwo",
                type: "uint256[]"
            },
            {
                internalType: "bytes32",
                name: "gameId",
                type: "bytes32"
            },
        ],
        name: "_startGame",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            },
        ],
        name: "cooldowns",
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
        inputs: [
            {
                internalType: "bytes32",
                name: "",
                type: "bytes32"
            },
        ],
        name: "matches",
        outputs: [
            {
                internalType: "uint8",
                name: "mapId",
                type: "uint8"
            },
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "rm",
        outputs: [
            {
                internalType: "contract rarity",
                name: "",
                type: "address"
            },
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "rmAttributes",
        outputs: [
            {
                internalType: "contract rarityAttributes",
                name: "",
                type: "address"
            },
        ],
        stateMutability: "view",
        type: "function"
    },
];
var _bytecode = "0x608060405273ce761d788df608bd21bdd59d6f4b54b2e27f25bb600260006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555073b5f5af1087a8da62a23b08c00c6ec9af21f397a1600360006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550737426dbe5207c2b5dac57d8e55f0959fcd99661d4600460006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055503480156200011057600080fd5b5060405162001ea338038062001ea3833981810160405281019062000136919062000219565b82600260006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555081600360006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555080600460006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550505050620002c8565b6000815190506200021381620002ae565b92915050565b600080600060608486031215620002355762000234620002a9565b5b6000620002458682870162000202565b9350506020620002588682870162000202565b92505060406200026b8682870162000202565b9150509250925092565b6000620002828262000289565b9050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600080fd5b620002b98162000275565b8114620002c557600080fd5b50565b611bcb80620002d86000396000f3fe608060405234801561001057600080fd5b506004361061007d5760003560e01c80639d6fac6f1161005b5780639d6fac6f146100ee5780639fe9ada31461011e578063a9f55f441461014e578063d0bc9a081461016a5761007d565b806306748fb114610082578063510fc61a146100a0578063731d6c40146100be575b600080fd5b61008a610188565b604051610097919061163e565b60405180910390f35b6100a86101ae565b6040516100b59190611674565b60405180910390f35b6100d860048036038101906100d391906112ae565b6101d4565b6040516100e59190611623565b60405180910390f35b61010860048036038101906101039190611366565b610406565b60405161011591906116bf565b60405180910390f35b61013860048036038101906101339190611339565b61041e565b60405161014591906116da565b60405180910390f35b61016860048036038101906101639190611223565b610449565b005b610172610642565b60405161017f9190611659565b60405180910390f35b600460009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60008084511180156101e7575082518451145b6101f057600080fd5b60005b8451811015610345573373ffffffffffffffffffffffffffffffffffffffff16600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16636352211e87848151811061026457610263611a9f565b5b60200260200101516040518263ffffffff1660e01b815260040161028891906116bf565b60206040518083038186803b1580156102a057600080fd5b505afa1580156102b4573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906102d891906111f6565b73ffffffffffffffffffffffffffffffffffffffff16146102f857600080fd5b60006001600087848151811061031157610310611a9f565b5b60200260200101518152602001908152602001600020541461033257600080fd5b808061033d906119f8565b9150506101f3565b5083836040516020016103599291906115e3565b60405160208183030381529060405280519060200120905060405180606001604052808581526020018481526020018360ff1681525060008083815260200190815260200160002060008201518160000190805190602001906103bd92919061104d565b5060208201518160010190805190602001906103da92919061104d565b5060408201518160020160006101000a81548160ff021916908360ff1602179055509050509392505050565b60016020528060005260406000206000915090505481565b60006020528060005260406000206000915090508060020160009054906101000a900460ff16905081565b6000835111801561045b575081518351145b61046457600080fd5b82826040516020016104779291906115e3565b60405160208183030381529060405280519060200120811461049857600080fd5b60005b600183516104a991906118a3565b811015610632573373ffffffffffffffffffffffffffffffffffffffff16600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16636352211e85848151811061051857610517611a9f565b5b60200260200101516040518263ffffffff1660e01b815260040161053c91906116bf565b60206040518083038186803b15801561055457600080fd5b505afa158015610568573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061058c91906111f6565b73ffffffffffffffffffffffffffffffffffffffff16146105ac57600080fd5b6000600160008584815181106105c5576105c4611a9f565b5b602002602001015181526020019081526020016000205414801561061657506000600160008684815181106105fd576105fc611a9f565b5b6020026020010151815260200190815260200160002054145b61061f57600080fd5b808061062a906119f8565b91505061049b565b5061063d8383610668565b505050565b600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600061067261109a565b60008060005b8651811015610a7c57600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166377d9e11c8883815181106106d2576106d1611a9f565b5b60200260200101516040518263ffffffff1660e01b81526004016106f691906116bf565b60c06040518083038186803b15801561070e57600080fd5b505afa158015610722573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061074691906113c0565b9091929394508463ffffffff16945090919250909150905050809550506005600460009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663438303bf8984815181106107b6576107b5611a9f565b5b60200260200101516040518263ffffffff1660e01b81526004016107da91906116bf565b60206040518083038186803b1580156107f257600080fd5b505afa158015610806573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061082a9190611393565b600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166338c9027a886040518263ffffffff1660e01b815260040161088591906116bf565b60206040518083038186803b15801561089d57600080fd5b505afa1580156108b1573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906108d59190611393565b6108df91906117c2565b6108e991906117c2565b925061092a6040518060400160405280601081526020017f696e69746961746976652069732025730000000000000000000000000000000081525084610f88565b6000805b838110156109e7578486826008811061094a57610949611a9f565b5b602002015110156109c557601e600160008b848151811061096e5761096d611a9f565b5b602002602001015181526020019081526020016000205461098f91906117c2565b600160008b84815181106109a6576109a5611a9f565b5b60200260200101518152602001908152602001600020819055506109d4565b81806109d0906119f8565b9250505b80806109df906119f8565b91505061092e565b5080601e6109f59190611849565b601e42610a0291906117c2565b610a0c91906117c2565b600160008a8581518110610a2357610a22611a9f565b5b602002602001015181526020019081526020016000208190555083858460088110610a5157610a50611a9f565b5b6020020181815250508280610a65906119f8565b935050508080610a74906119f8565b915050610678565b5060005b8551811015610f4857600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166377d9e11c878381518110610ada57610ad9611a9f565b5b60200260200101516040518263ffffffff1660e01b8152600401610afe91906116bf565b60c06040518083038186803b158015610b1657600080fd5b505afa158015610b2a573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610b4e91906113c0565b9091929394508463ffffffff16945090919250909150905050809550506005600460009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663438303bf888481518110610bbe57610bbd611a9f565b5b60200260200101516040518263ffffffff1660e01b8152600401610be291906116bf565b60206040518083038186803b158015610bfa57600080fd5b505afa158015610c0e573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610c329190611393565b600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166338c9027a886040518263ffffffff1660e01b8152600401610c8d91906116bf565b60206040518083038186803b158015610ca557600080fd5b505afa158015610cb9573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610cdd9190611393565b610ce791906117c2565b610cf191906117c2565b9250610d326040518060400160405280601081526020017f696e69746961746976652069732025730000000000000000000000000000000081525084610f88565b6000805b83811015610eb35788518111610de95784868260088110610d5a57610d59611a9f565b5b60200201511015610dd557601e600160008b8481518110610d7e57610d7d611a9f565b5b6020026020010151815260200190815260200160002054610d9f91906117c2565b600160008b8481518110610db657610db5611a9f565b5b6020026020010151815260200190815260200160002081905550610de4565b8180610de0906119f8565b9250505b610ea0565b84868260088110610dfd57610dfc611a9f565b5b60200201511015610e9057601e600160008a600285610e1c9190611818565b81518110610e2d57610e2c611a9f565b5b6020026020010151815260200190815260200160002054610e4e91906117c2565b600160008a600285610e609190611818565b81518110610e7157610e70611a9f565b5b6020026020010151815260200190815260200160002081905550610e9f565b8180610e9b906119f8565b9250505b5b8080610eab906119f8565b915050610d36565b5080601e610ec19190611849565b601e42610ece91906117c2565b610ed891906117c2565b60016000898581518110610eef57610eee611a9f565b5b602002602001015181526020019081526020016000208190555083858460088110610f1d57610f1c611a9f565b5b6020020181815250508280610f31906119f8565b935050508080610f40906119f8565b915050610a80565b507fe606b2034bea4c1fe27dc348815539a1841eb7eb42821629ae9a49b47ce9a16983604051610f789190611607565b60405180910390a1505050505050565b6110208282604051602401610f9e92919061168f565b6040516020818303038152906040527f9710a9d0000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19166020820180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff8381831617835250505050611024565b5050565b60008151905060006a636f6e736f6c652e6c6f679050602083016000808483855afa5050505050565b828054828255906000526020600020908101928215611089579160200282015b8281111561108857825182559160200191906001019061106d565b5b50905061109691906110bd565b5090565b604051806101000160405280600890602082028036833780820191505090505090565b5b808211156110d65760008160009055506001016110be565b5090565b60006110ed6110e88461171a565b6116f5565b905080838252602082019050828560208602820111156111105761110f611b02565b5b60005b85811015611140578161112688826111a2565b845260208401935060208301925050600181019050611113565b5050509392505050565b60008151905061115981611b22565b92915050565b600082601f83011261117457611173611afd565b5b81356111848482602086016110da565b91505092915050565b60008135905061119c81611b39565b92915050565b6000813590506111b181611b50565b92915050565b6000815190506111c681611b50565b92915050565b6000815190506111db81611b67565b92915050565b6000813590506111f081611b7e565b92915050565b60006020828403121561120c5761120b611b0c565b5b600061121a8482850161114a565b91505092915050565b60008060006060848603121561123c5761123b611b0c565b5b600084013567ffffffffffffffff81111561125a57611259611b07565b5b6112668682870161115f565b935050602084013567ffffffffffffffff81111561128757611286611b07565b5b6112938682870161115f565b92505060406112a48682870161118d565b9150509250925092565b6000806000606084860312156112c7576112c6611b0c565b5b600084013567ffffffffffffffff8111156112e5576112e4611b07565b5b6112f18682870161115f565b935050602084013567ffffffffffffffff81111561131257611311611b07565b5b61131e8682870161115f565b925050604061132f868287016111e1565b9150509250925092565b60006020828403121561134f5761134e611b0c565b5b600061135d8482850161118d565b91505092915050565b60006020828403121561137c5761137b611b0c565b5b600061138a848285016111a2565b91505092915050565b6000602082840312156113a9576113a8611b0c565b5b60006113b7848285016111b7565b91505092915050565b60008060008060008060c087890312156113dd576113dc611b0c565b5b60006113eb89828a016111cc565b96505060206113fc89828a016111cc565b955050604061140d89828a016111cc565b945050606061141e89828a016111cc565b935050608061142f89828a016111cc565b92505060a061144089828a016111cc565b9150509295509295509295565b600061145983836115a7565b60208301905092915050565b600061147183836115c5565b60208301905092915050565b61148681611760565b611490818461179b565b925061149b82611746565b8060005b838110156114cc5781516114b3878261144d565b96506114be83611781565b92505060018101905061149f565b505050505050565b60006114df8261176b565b6114e981856117a6565b93506114f483611750565b8060005b8381101561152557815161150c8882611465565b97506115178361178e565b9250506001810190506114f8565b5085935050505092915050565b61153b816118e9565b82525050565b61154a8161193a565b82525050565b6115598161194c565b82525050565b6115688161195e565b82525050565b600061157982611776565b61158381856117b1565b9350611593818560208601611994565b61159c81611b11565b840191505092915050565b6115b081611913565b82525050565b6115bf81611913565b82525050565b6115ce81611913565b82525050565b6115dd8161192d565b82525050565b60006115ef82856114d4565b91506115fb82846114d4565b91508190509392505050565b60006101008201905061161d600083018461147d565b92915050565b60006020820190506116386000830184611532565b92915050565b60006020820190506116536000830184611541565b92915050565b600060208201905061166e6000830184611550565b92915050565b6000602082019050611689600083018461155f565b92915050565b600060408201905081810360008301526116a9818561156e565b90506116b860208301846115b6565b9392505050565b60006020820190506116d460008301846115b6565b92915050565b60006020820190506116ef60008301846115d4565b92915050565b60006116ff611710565b905061170b82826119c7565b919050565b6000604051905090565b600067ffffffffffffffff82111561173557611734611ace565b5b602082029050602081019050919050565b6000819050919050565b6000819050602082019050919050565b600060089050919050565b600081519050919050565b600081519050919050565b6000602082019050919050565b6000602082019050919050565b600081905092915050565b600081905092915050565b600082825260208201905092915050565b60006117cd82611913565b91506117d883611913565b9250827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0382111561180d5761180c611a41565b5b828201905092915050565b600061182382611913565b915061182e83611913565b92508261183e5761183d611a70565b5b828204905092915050565b600061185482611913565b915061185f83611913565b9250817fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff048311821515161561189857611897611a41565b5b828202905092915050565b60006118ae82611913565b91506118b983611913565b9250828210156118cc576118cb611a41565b5b828203905092915050565b60006118e2826118f3565b9050919050565b6000819050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000819050919050565b600063ffffffff82169050919050565b600060ff82169050919050565b600061194582611970565b9050919050565b600061195782611970565b9050919050565b600061196982611970565b9050919050565b600061197b82611982565b9050919050565b600061198d826118f3565b9050919050565b60005b838110156119b2578082015181840152602081019050611997565b838111156119c1576000848401525b50505050565b6119d082611b11565b810181811067ffffffffffffffff821117156119ef576119ee611ace565b5b80604052505050565b6000611a0382611913565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff821415611a3657611a35611a41565b5b600182019050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b600080fd5b600080fd5b600080fd5b600080fd5b6000601f19601f8301169050919050565b611b2b816118d7565b8114611b3657600080fd5b50565b611b42816118e9565b8114611b4d57600080fd5b50565b611b5981611913565b8114611b6457600080fd5b50565b611b708161191d565b8114611b7b57600080fd5b50565b611b878161192d565b8114611b9257600080fd5b5056fea26469706673582212206330be6ef1bf2b13685e4e948aa180a51b68f0529590080312697e10b980e1b164736f6c63430008070033";
var MatchMaker__factory = /** @class */ (function (_super) {
    __extends(MatchMaker__factory, _super);
    function MatchMaker__factory(signer) {
        return _super.call(this, _abi, _bytecode, signer) || this;
    }
    MatchMaker__factory.prototype.deploy = function (rarityAddress, rarityAttrAddress, codexBaseRandomAddress, overrides) {
        return _super.prototype.deploy.call(this, rarityAddress, rarityAttrAddress, codexBaseRandomAddress, overrides || {});
    };
    MatchMaker__factory.prototype.getDeployTransaction = function (rarityAddress, rarityAttrAddress, codexBaseRandomAddress, overrides) {
        return _super.prototype.getDeployTransaction.call(this, rarityAddress, rarityAttrAddress, codexBaseRandomAddress, overrides || {});
    };
    MatchMaker__factory.prototype.attach = function (address) {
        return _super.prototype.attach.call(this, address);
    };
    MatchMaker__factory.prototype.connect = function (signer) {
        return _super.prototype.connect.call(this, signer);
    };
    MatchMaker__factory.createInterface = function () {
        return new ethers_1.utils.Interface(_abi);
    };
    MatchMaker__factory.connect = function (address, signerOrProvider) {
        return new ethers_1.Contract(address, _abi, signerOrProvider);
    };
    MatchMaker__factory.bytecode = _bytecode;
    MatchMaker__factory.abi = _abi;
    return MatchMaker__factory;
}(ethers_1.ContractFactory));
exports.MatchMaker__factory = MatchMaker__factory;