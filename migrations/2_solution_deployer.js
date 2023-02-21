var ExerciceSolution = artifacts.require("ExerciceSolution.sol");
var ExerciceSolutionTest = artifacts.require("AntoineRevel_SolutionTest.sol");
var TokenToSwap = artifacts.require("TokenToSwap.sol");

var Evaluator="0xbF1D55027644401a4d3865536E4d94a0E34F15e6";
var DummyToken="0x2aF483edaE4cce53186E6ed418FE92f8169Ad74E";

var UniswapV2Router02="0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
var tdToken="0x22E065dAE8e21d31ca04c1695d464D28C7b6014B";

module.exports = (deployer, network) => {
    deployer.then(async () => {
        if (network=="goerli") {
            await deployExerciceSolution();
            await deployToken()
        }
        await deployRecap();
    });
};


async function deployExerciceSolution() {
    myTest = await ExerciceSolutionTest.new(Evaluator,UniswapV2Router02,DummyToken,tdToken,{ value : 3000});
}

async function deployToken() {
    ticker = await myTest.getTicker();
    supply = await myTest.getSupply();
    myTokenToSwap= await TokenToSwap.new(ticker,supply,myTest.address);
    mySolution = await ExerciceSolution.new(UniswapV2Router02,DummyToken,myTokenToSwap.address,{ value : 1000});
    value = await mySolution.getValue.call();
    console.log("value solution : "+ value);
    valuetest = await myTest.getValue.call();
    console.log("value test : "+ valuetest);
    await myTest.continueClaim(myTokenToSwap.address,mySolution.address);
}

async function deployRecap() {
    console.log("mySolution address : " + mySolution.address);
    console.log("myTest address : " + myTest.address);
    console.log("Token to swap address : " + myTokenToSwap.address);


    ttsBalance= await myTokenToSwap.balanceOf(myTest.address);
    console.log("Token to swap balance (myTest) : "+ ttsBalance );

    pointTD= await myTest.getPoint.call();
    console.log("Point : "+ pointTD );
}