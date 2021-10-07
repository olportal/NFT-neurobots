const BN = require('bn.js');

require('dotenv').config();
const {
    DEPLOY_GAS_LIMIT_MAX,
    DEPLOY_GAS_LIMIT_TOKEN,
    LIME_FEE_ADDRESS,
    ROUTER_ADDRESS
} = process.env;

const MarketPlaceContract = artifacts.require("IMeMarketPlace");
const NFTContract = artifacts.require("IMeNFT");
const TestLIMEContract = artifacts.require("TestLIME");
const TestOLCFContract = artifacts.require("TestOLCF");
const TestUSDCContract = artifacts.require("TestUSDC");

const ZERO = new BN(0);
const ONE = new BN(1);

module.exports = async function (deployer, network) {
    // await deployer.deploy(
    //     NFTContract,
    //     {gas: DEPLOY_GAS_LIMIT_MAX}
    // );
    // const NFTContractInst = await NFTContract.deployed();
    // console.log('NFT address: ', NFTContractInst.address)
    //
    // await deployer.deploy(
    //     TestLIMEContract,
    //     {gas: DEPLOY_GAS_LIMIT_TOKEN}
    // );
    // let TestLIMEContractInst = await TestLIMEContract.deployed();
    // console.log('LIME address: ', TestLIMEContractInst.address)
    //
    // await deployer.deploy(
    //     TestUSDCContract,
    //     {gas: DEPLOY_GAS_LIMIT_TOKEN}
    // );
    // let TestUSDCContractInst = await TestUSDCContract.deployed();
    // console.log('USDC address: ', TestUSDCContractInst.address)
    //
    // await deployer.deploy(
    //     TestOLCFContract,
    //     {gas: DEPLOY_GAS_LIMIT_TOKEN}
    // );
    // let TestOLCFContractInst = await TestOLCFContract.deployed();
    // console.log('OLCF address: ', TestOLCFContractInst.address)

    await deployer.deploy(
        MarketPlaceContract,
        // TestLIMEContractInst.address,
        // TestOLCFContractInst.address,
        // TestUSDCContractInst.address,
        // NFTContractInst.address,
        '0xcD3C34cEFD4B671c338e4012390097a98a2B6ABD',
        '0x6E86EE49A15d44f96667c8c0499a274c22C2c5b6',
        '0xd9A5f35f89E0F8f86049EfD74a9bbF866d81E7B8',
        '0xE72a5892575bAcBBBdf514f222Cf7C560aDB9531',
        LIME_FEE_ADDRESS,
        ROUTER_ADDRESS,
        {gas: DEPLOY_GAS_LIMIT_MAX}
    );
    let MarketPlaceContractInst = await MarketPlaceContract.deployed();
    console.log('MarketPlace address: ', MarketPlaceContractInst.address)
};