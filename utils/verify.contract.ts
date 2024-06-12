import { exec } from "child_process";
import chalk from "chalk";

export const verifyContract = async (
  contractAddress: string,
  network: string,
  contractArgs?: any[]
) => {
  const script = "npx hardhat verify --network " + network;
  const scriptWithContractAddress = script.concat(" ", contractAddress);
  const scriptToExec =
    contractArgs && contractArgs.length > 0
      ? scriptWithContractAddress.concat(" ", contractArgs.join(" "))
      : scriptWithContractAddress;
  exec(scriptToExec, (error, stdout, stderr) => {
    if (error) {
      console.log(chalk.red(`error: ${error.message}`));
    } else {
      console.log(
        chalk.green(
          `Successful contract verification: ${contractAddress} on ${network}`
        )
      );
    }
  });
};

export const verifyContractWithFileArgs = async (
  contractAddress: string,
  network: string,
  filePath: string
) => {
  const script = "npx hardhat verify --network " + network;
  const scriptWithContractAddress = script.concat(" ", contractAddress);
  const scriptToExec = scriptWithContractAddress.concat(
    " --constructor-args ",
    filePath
  );
  exec(scriptToExec, (error, stdout, stderr) => {
    if (error) {
      console.log(chalk.red(`error: ${error.message}`));
    } else {
      console.log(
        chalk.green(
          `Successful contract verification: ${contractAddress} on ${network}`
        )
      );
    }
  });
};
