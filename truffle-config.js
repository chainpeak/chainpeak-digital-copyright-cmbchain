const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {

  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    cmbc: {
      provider: () => {
        return new HDWalletProvider({
          privateKeys: process.env.CMBC_PRIVATE_KEY,
          providerOrUrl: 'ws://192.168.2.59:4341',
          chainId: 0,
        });
      },
      network_id: "0",       // Any network (default: none)
    },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.5.17",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
        //  evmVersion: "byzantium"
      }
    }
  },
  plugins: ["truffle-plugin-verify", "truffle-contract-size"],
};
