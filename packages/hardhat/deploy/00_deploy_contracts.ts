import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

// TODO: check these before deploying
const initialOwner = "0x7349d6e55cB3F737249FbAa047C16b826559B127"; // drcoder.eth
// const initialBeneficiary = "0xc5D621B4f44D987a49f45A2c5dE91B10A1f221bE"; // Use this for Goerli testing
const initialBeneficiary = "0xc3A2154DE8B6D4BF0b94EBf8EEfF2c313b86444b"; // Use this for Optimism deployment

/**
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployContracts: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  /*
    On localhost, the deployer account is the one that comes with Hardhat, which is already funded.

    When deploying to live networks (e.g `yarn deploy --network goerli`), the deployer account
    should have sufficient balance to pay for the gas fees for contract creation.

    You can generate a random account with `yarn generate` which will fill DEPLOYER_PRIVATE_KEY
    with a random private key in the .env file (then used on hardhat.config.ts)
    You can run the `yarn account` command to check your balance in every network.
  */
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  await deploy("MondrianShapes", {
    from: deployer,
    args: [], // Contract constructor arguments
    log: true,
    // autoMine: can be passed to the deploy function to make the deployment process faster on local networks by
    // automatically mining the contract deployment transaction. There is no effect on live networks.
    autoMine: true,
  });

  // Get the deployed contract
  const mondrianShapes = await hre.ethers.getContract("MondrianShapes", deployer);

  await deploy("MondrianFrames", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  const mondrianFrames = await hre.ethers.getContract("MondrianFrames", deployer);

  await deploy("MovingMondrian", {
    from: deployer,
    args: [initialOwner, initialBeneficiary, mondrianFrames.address, mondrianShapes.address],
    log: true,
    autoMine: true,
  });
};

export default deployContracts;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags MovingMondrian
deployContracts.tags = ["MovingMondrian", "SharedFnsAndData"];
