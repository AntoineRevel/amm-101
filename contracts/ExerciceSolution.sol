pragma solidity ^0.6.2;

import "./IExerciceSolution.sol";

contract ExerciceSolution is IExerciceSolution {
    constructor() public {}
    function addLiquidity() external override {}

    function withdrawLiquidity() external override {}

    function swapYourTokenForDummyToken() external override {}

    function swapYourTokenForEth() external override {}

}
