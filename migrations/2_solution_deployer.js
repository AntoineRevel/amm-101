var ExerciceSolution = artifacts.require("ExerciceSolution.sol");
var ExerciceSolutionTest = artifacts.require("AntoineRevel_SolutionTest.sol");
var TokenToSwap = artifacts.require("TokenToSwap.sol");

var Evaluator = "0xF468D9B2d1D901B01147179baF8526de39a59d6B";
var DummyToken = "0x0CA2F5Ff2a0bB722f8903A26ae442bAFDD26Eb43";

var UniswapV2Router02 = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
var tdToken = "0xC23563f0D0b4cD110b561DaBd707539AFf99a42C";

module.exports = (deployer, network) => {
    deployer.then(async () => {
        if (network == "goerli") {
            await deployExerciceSolution();
            await deployToken()
        }
        await deployRecap();
    });
};


async function deployExerciceSolution() {
    myTest = await ExerciceSolutionTest.new(Evaluator, UniswapV2Router02, DummyToken, tdToken, {value: 3000});
}

async function deployToken() {
    ticker = await myTest.getTicker();
    supply = await myTest.getSupply();
    myTokenToSwap = await TokenToSwap.new(ticker, supply, myTest.address);
    mySolution = await ExerciceSolution.new(UniswapV2Router02, DummyToken, myTokenToSwap.address, {value: 2000});
    value = await mySolution.getValue.call();
    console.log("value solution : " + value);
    valuetest = await myTest.getValue.call();
    console.log("value test : " + valuetest);
    await myTest.continueClaim(myTokenToSwap.address, mySolution.address);
    await myTest.continueClaim2();
}

async function deployRecap() {
    console.log("mySolution address : " + mySolution.address);
    console.log("myTest address : " + myTest.address);
    console.log("Token to swap address : " + myTokenToSwap.address);


    ttsBalance = await myTokenToSwap.balanceOf(myTest.address);
    console.log("Token to swap balance (myTest) : " + ttsBalance);

    pointTD = await myTest.getPoint.call();
    console.log("Point : " + pointTD);
}