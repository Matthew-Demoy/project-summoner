//user can create a game
//user can start a game
//user can move characters
//estimate gas cost of operations

import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";
import { rarity } from "../addresses/rarity";
import { League__factory, Rarity__factory } from "../typechain";
import { classIdtoName } from "../utils/classes";
describe("Rarity Battle Test", () => {
  let rarity: Contract;
  before("Should mint new summoners", async () => {
      
    const [owner, addr1] = await ethers.getSigners();
    const RarityContractFactory = await ethers.getContractFactory(
      "contracts/rarity.sol:rarity",
      owner,
    );

    rarity = await RarityContractFactory.deploy();

    let i = 1;

    while (i < 4) {
      await rarity.summon(i);
      i++;
    }

    i = 1;

    while (i < 4) {
      await rarity.summon(i);
      i++;
    }

    i = 1;
    while (i < 8) {
      const summoner = await rarity.summoner(i);
      i++;
      console.log(classIdtoName(summoner._class.toNumber()));
    }
  });

  it("should create a game", async () => {
    const [owner, addr1] = await ethers.getSigners();
    const LeagueContractFactory = await ethers.getContractFactory(
      "contracts/Matchmaker.sol:League",
      owner
    )  as League__factory
    
    //@ts-ignore
    const league = await LeagueContractFactory.deploy(rarity.address, rarity.address, rarity.address);
    
    const team1 = [1,2,3,4];
    const team2 = [5,6,7,8];
   // const createGameTx = await league.callStatic.createGame(team1, team2, 1).then(res => res);
    
    await expect( league.createGame(team1, team2, 1)).to.emit(league, "createGameEvent")
    
    const createGameEventFilter = league.filters.createGameEvent()
    const events =  await league.queryFilter(createGameEventFilter ,"latest");
    console.log(events)
    
  });
});
