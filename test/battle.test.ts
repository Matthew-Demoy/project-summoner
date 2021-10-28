//user can create a game
//user can start a game
//user can move characters
//estimate gas cost of operations

import { expect } from "chai";
import { Contract, providers } from "ethers";
import { ethers } from "hardhat";
import {
  CodexBaseRandom__factory,
  League__factory,
  Rarity__factory,
} from "../typechain";
describe("Rarity Battle Test", () => {
  let rarity: Contract;
  let rarity_attributes: Contract;
  let random: Contract;

  before("Should mint new summoners", async () => {
    const [owner, addr1] = await ethers.getSigners();
    const RarityContractFactory = await ethers.getContractFactory(
      "contracts/core/rarity.sol:rarity",
      owner
    );

    rarity = await RarityContractFactory.deploy();

    let i = 1;
    while (i < 9) {
      await rarity.summon(i);
      i++;
    }

    const RarityAttributesFactory = await ethers.getContractFactory(
      "contracts/core/attributes.sol:rarity_attributes",
      owner
    );
    rarity_attributes = await RarityAttributesFactory.deploy(rarity.address);

    i = 0;
    while (i < 8) {
      await rarity.setApprovalForAll(rarity_attributes.address, true);
      await rarity.approve(rarity_attributes.address, i);
      await rarity_attributes.point_buy(i, 8, 14, 14, 10, 10, 18);
      i++;
    }

    const RandomFactory = await ethers.getContractFactory(
      "contracts/codex/codex-base-random.sol:codex",
      owner
    );
    random = await RandomFactory.deploy();
  });

  it("should create a game", async () => {
    const [owner, addr1] = await ethers.getSigners();
    const LeagueContractFactory = (await ethers.getContractFactory(
      "contracts/Matchmaker.sol:League",
      owner
    )) as League__factory;

    //@ts-ignore
    const league = await LeagueContractFactory.deploy(
      rarity.address,
      //@ts-ignore
      rarity_attributes.address,
      random.address
    );

    const team1 = [1, 2, 3, 4];
    const team2 = [5, 6, 7, 8];

    await expect(league.createGame(team1, team2, 1)).to.emit(
      league,
      "createGameEvent"
    );
    const createGameEventFilter = league.filters.createGameEvent();
    const events = await league.queryFilter(createGameEventFilter, "latest");

    const events2 = await league.on(
      createGameEventFilter,
      (hash, name, metadata) => {
        metadata
      }
    );
  });

  it("should emit a start game event with address and gameId metadata", async () => {
    const [owner, addr1] = await ethers.getSigners();
    const LeagueContractFactory = (await ethers.getContractFactory(
      "contracts/Matchmaker.sol:League",
      owner
    )) as League__factory;

    //@ts-ignore
    const league = await LeagueContractFactory.deploy(
      rarity.address,
      //@ts-ignore
      rarity_attributes.address,
      random.address
    );

    const team1 = [1, 2, 3, 4];
    const team2 = [5, 6, 7, 8];

    await expect(league.createGame(team1, team2, 1)).to.emit(
      league,
      "createGameEvent"
    );

    const createGameEventFilter = league.filters.createGameEvent(
      owner.address,
      null
    );

    await league.on(
      createGameEventFilter,
      (hash, name, metadata) => {
        console.log("metadata " + metadata);
      }
    );

    const gameId = await league.callStatic.createGame(team1, team2, 1);
  });

  it("should start a game with ordered initiatives", async () => {
    const [owner, addr1] = await ethers.getSigners();
    const LeagueContractFactory = (await ethers.getContractFactory(
      "contracts/Matchmaker.sol:League",
      owner
    )) as League__factory;

    //@ts-ignore
    const league = await LeagueContractFactory.deploy(
      rarity.address,
      //@ts-ignore
      rarity_attributes.address,
      random.address
    );

    const team1 = [0, 1, 2, 3];
    const team2 = [4, 5, 6, 7];
    // const createGameTx = await league.callStatic.createGame(team1, team2, 1).then(res => res);
    const gameId = await league.callStatic.createGame(team1, team2, 1);
    await league._startGame(team1, team2, gameId);
    const timestampFactory = await ethers.getContractFactory(
      "contracts/timestamp.sol:timestamp",
      owner
    );

    const timestamp = await timestampFactory.deploy();

    const time = await timestamp.getTimestamp();

    const bothTeams = team1.concat(team2);

    const cooldowns = await bothTeams.map(async (summoner) => {
      return await league.cooldowns(summoner);
    });
    const unique = new Set(cooldowns).size == cooldowns.length;

    expect(unique).equals(true);
  });


});
