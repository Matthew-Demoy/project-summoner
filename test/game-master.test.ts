import { ethers } from "hardhat";
import { expect } from "chai";
import { Rarity__factory } from "../typechain";
import { classIdtoName } from "../utils/classes";
describe("GM Test", () => {
  it("Should mint new summoners", async () => {
    const [owner, addr1] = await ethers.getSigners();
    const RarityContractFactory = await ethers.getContractFactory(
     "contracts/core/rarity.sol:rarity",
      owner
    )
    
    const rarity = await RarityContractFactory.deploy();

    let i = 1;

    while (i < 11) {
      await rarity.summon(i);
      i++;
    }

    i = 1;
    while (i < 11) {
      const summoner = await rarity.summoner(i);
      i++;
    }
  });
});
