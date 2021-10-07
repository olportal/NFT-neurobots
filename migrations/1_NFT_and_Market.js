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
        '0x6e432Acc9AF12176409672F21aB684Eb1dE38e46',
        '0x88c437e6B53D36f179A6C53987867388e324Fdf3',
        '0xf45999FFe33491e7100eDd46324251661a707d97',
        '0xA6F0Ca23a2dc07A7C5F00674ff403c0cc1fb7ed8',
        LIME_FEE_ADDRESS,
        ROUTER_ADDRESS,
        {gas: DEPLOY_GAS_LIMIT_MAX}
    );
    let MarketPlaceContractInst = await MarketPlaceContract.deployed();
    console.log('MarketPlace address: ', MarketPlaceContractInst.address)
};