import { HardhatUserConfig, vars } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import "@nomicfoundation/hardhat-viem";
import "@nomicfoundation/hardhat-foundry";
import "dotenv/config";


const config: HardhatUserConfig = {
  defaultNetwork: "base",
  solidity: {
    compilers: [
      {
        version: "0.8.24",
        settings: { optimizer: { enabled: true, runs: 200 } },
      },
      {
        version: "0.8.22",
        settings: { optimizer: { enabled: true, runs: 200 } },
      },
    ],
  },
  networks: {
    base: {
      url: process.env.BASE_URL || "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
    baseSepolia: {
      url: process.env.BASE_SEPOLIA_URL || "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
    hardhat: {
      forking: {
        url: process.env.BASE_URL || "",
        blockNumber: process.env.BLOCKNUMBER
          ? parseInt(process.env.BLOCKNUMBER)
          : undefined,
      },
      blockGasLimit: 30_000_000,
    },
  },
  etherscan: {
    apiKey: {
      base: process.env.BASESCAN_API_KEY as string,
      baseSepolia: process.env.BASESCAN_API_KEY as string,
    },
    customChains: [
      {
        network: "baseSepolia",
        chainId: 84532,
        urls: {
          apiURL: process.env.BASESCAN_SEPOLIA_API_URL as string,
          browserURL: process.env.BASESCAN_SEPOLIA_EXPLORER_URL as string,
        },
      },
    ],
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS ? true : false,
    currency: (process.env.CURRENCY as string) || "USD",
    coinmarketcap: process.env.COINMARKETCAP_API_KEY
      ? process.env.COINMARKETCAP_API_KEY
      : "",
  },
};

export default config;
