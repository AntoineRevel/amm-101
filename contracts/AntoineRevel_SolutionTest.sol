pragma solidity ^0.8.0;

import "./Evaluator.sol";

contract AntoineRevel_SolutionTest {
    Evaluator evaluator;
    IExerciceSolution solution;

    constructor(IExerciceSolution _solution, Evaluator _evaluator){
        evaluator = _evaluator;
        solution = _solution;
        submitExercice();
    }

    function submitExercice() private {
        evaluator.submitExercice(solution);
    }


}
