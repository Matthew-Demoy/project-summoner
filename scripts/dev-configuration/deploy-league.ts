import { ethers, network } from "hardhat";
import { League__factory } from "../../typechain";
import { addresses } from "../../utils/addresses";

if (network.name !== "localhost") {
  console.log("script should be ran locally only! \n Exiting now");
  process.exit(1);
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

  console.log(league.address);

  return league.address;
};


deployMatchmaker()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
