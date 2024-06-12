import hre from "hardhat";
import { verifyContract } from "../utils/verify.contract";

async function main() {
  const [deployer] = await hre.viem.getWalletClients();
  const deployerAddress = deployer.account.address;
  
  const lootContract = await hre.viem.deployContract("Loot", [deployerAddress]);
  console.log(`The loot contract has been deployed at ${lootContract.address}`);

  await verifyContract(lootContract.address, hre.network.name, [
    deployerAddress,
  ]);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
