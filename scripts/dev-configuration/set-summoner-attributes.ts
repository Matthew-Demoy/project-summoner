import { ethers, network } from "hardhat";
import { deployedSummonerIds } from "../../utils/summoners";
import { addresses } from "../../utils/addresses";

if (network.name !== "localhost") {
  console.log("script should be ran locally only! \n Exiting now");
  process.exit(1);
}

const user1Addr = "0x531BD0f4Bd8FBF2F18C77Ba1e07D633Bc9452731";
const user2Addr = "0x7b0E4823aA3286a58Dfcc3aC66Fff2c0eE46F686";
async function config() {
    const address = addresses.rarityAtributes;

  const RarityAttributesFactory = await ethers.getContractFactory(
    "contracts/core/attributes.sol:rarity_attributes"
  );

  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [user1Addr],
  });

  const summonerHolderOne = await ethers.getSigner(
    user1Addr
  );
  const rarityAtributes = await RarityAttributesFactory.attach(address);

  let attributesSigner = rarityAtributes.connect(summonerHolderOne);


  const RarityContractFactory = await ethers.getContractFactory(
    "contracts/core/rarity.sol:rarity"
  );

  const rarity = await RarityContractFactory.attach(addresses.rarity);
  let rm = rarity.connect(summonerHolderOne);

  for await (const summoner of deployedSummonerIds.slice(0, 4)) {
    const res = await attributesSigner.ability_scores(summoner);
    console.log(res)
    await rm.setApprovalForAll(address, true);
    
    await rm.approve(address, summoner);
    await attributesSigner.point_buy(summoner, 8, 14, 14, 10, 10, 18);
  }
  
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [user2Addr],
  });
  const summonerHolderTwo = await ethers.getSigner(
    user2Addr
  );
  rm = rarity.connect(summonerHolderTwo);
  attributesSigner = rarityAtributes.connect(summonerHolderTwo);
  for await (const summoner of deployedSummonerIds.slice(4, 8)) {
    await rm.setApprovalForAll(address, true);
    await rm.approve(address, summoner);
    await attributesSigner.point_buy(summoner, 8, 14, 14, 10, 10, 18);
  }
}


config()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
