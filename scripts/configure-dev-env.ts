async function config() {
  console.log("adding eth");
  await hre.network.provider.send("hardhat_setBalance", [
    "0x531BD0f4Bd8FBF2F18C77Ba1e07D633Bc9452731",
    hre.ethers.utils.parseEther("1000.0"),
  ]);


}

config()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

