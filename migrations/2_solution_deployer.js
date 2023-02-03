var ExerciceSolution = artifacts.require("ExerciceSolution.sol");
var ExerciceSolutionTest = artifacts.require("AntoineRevel_SolutionTest.sol");

var Evaluator = artifacts.require("Evaluator.sol");
var DummyToken= artifacts.require("DummyToken.sol");

module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        if (network == "goerli") {
            await setStaticContracts();
            await deployExerciceSolution();
            await deployRecap();
            await myTest.startClaimPoint();
            await printPoint();
        }
    });
};

async function setStaticContracts() {

    Evaluator = await evaluator.at("0xbF1D55027644401a4d3865536E4d94a0E34F15e6")
}


async function deployExerciceSolution() {
    mySolution= await ExerciceSolution.new(ClaimableToken.address,mySolutionToken.address);
    await mySolutionToken.setMinter(mySolution.address,true);
    myTest= await ExerciceSolutionTest.new(mySolution.address,Evaluator.address,TDToken.address,ClaimableToken.address,mySolutionToken.address);

}