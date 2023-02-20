var ExerciceSolution = artifacts.require("ExerciceSolution.sol");
var ExerciceSolutionTest = artifacts.require("AntoineRevel_SolutionTest.sol");

var Evaluator="0xbF1D55027644401a4d3865536E4d94a0E34F15e6";
var DummyToken="0x2aF483edaE4cce53186E6ed418FE92f8169Ad74E";


var UniswapV2Router02="0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
var tdToken="0x22E065dAE8e21d31ca04c1695d464D28C7b6014B";

module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        if (network == "goerli") {
            await deployExerciceSolution();
        } else if (network == "ganache") {
            await deploylocalExerciceSolution();
        }
        await deployRecap();
    });
};


async function deployExerciceSolution() {
    mySolution = await ExerciceSolution.new();
    myTest = await ExerciceSolutionTest.new(mySolution.address, Evaluator,UniswapV2Router02,DummyToken,tdToken);
}

async function deploylocalExerciceSolution() {
    mySolution = await ExerciceSolution.new();
    myTest = await ExerciceSolutionTest.new(mySolution.address, LocalEvaluator,UniswapV2Router02);

}

async function deployRecap() {
    console.log("mySolution " + mySolution.address);
    console.log("myTest " + myTest.address);
}