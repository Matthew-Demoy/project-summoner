import { rarity } from "../abis/rarity";
import { ethers, network } from "hardhat";
import { League__factory, Rarity__factory } from "../typechain";
import { deployedSummonerIds } from "../utils/summoners";
import { addresses } from "../utils/addresses";

if (network.name !== "localhost") {
  console.log("script should be ran locally only! \n Exiting now");
  process.exit(1);
}

const user1Addr = "0x531BD0f4Bd8FBF2F18C77Ba1e07D633Bc9452731";
const user2Addr = "0x7b0E4823aA3286a58Dfcc3aC66Fff2c0eE46F686";
async function config() {
  await hre.network.provider.send("hardhat_setBalance", [
    user1Addr,
    "0xFFFFFFFFFFFFFFFFFFFFFF",
  ]);

  await hre.network.provider.send("hardhat_setBalance", [
    user2Addr,
    "0xFFFFFFFFFFFFFFFFFFFFFF",
  ]);

  const RarityContractFactory = await ethers.getContractFactory(
    "contracts/core/rarity.sol:rarity"
  );

  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: ["0x49e2510A8947fA90c291c25a432477Bd1C570349"],
  });

  const summonerHolder = await ethers.getSigner(
    "0x49e2510A8947fA90c291c25a432477Bd1C570349"
  );

  const rarity = await RarityContractFactory.attach(
    "0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb"
  );

  const rm = rarity.connect(summonerHolder);

  for await (const summoner of deployedSummonerIds.slice(0, 4)) {
    await rm.setApprovalForAll(user1Addr, true);

    await rm.approve(user1Addr, summoner);

    await rm.transferFrom(summonerHolder.address, user1Addr, summoner);

    console.log(await rarity.ownerOf(summoner));
  }

  for await (const summoner of deployedSummonerIds.slice(5, 9)) {
    await rm.approve(user2Addr, summoner);
    await rm.setApprovalForAll(user2Addr, true);

    await rm.transferFrom(summonerHolder.address, user2Addr, summoner);

    console.log(await rarity.ownerOf(summoner));
  }
}

const deployMatchmaker = async () => {
  const [owner, addr1] = await ethers.getSigners();
  const LeagueContractFactory = (await ethers.getContractFactory(
    "contracts/Matchmaker.sol:League",
    owner
  )) as League__factory;

  const league = await LeagueContractFactory.deploy(
    addresses.rarity,
    addresses.rarityAtributes,
    addresses.random
  );

  console.log(league.address)
};

deployMatchmaker()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
