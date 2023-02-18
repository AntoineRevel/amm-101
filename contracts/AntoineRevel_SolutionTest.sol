pragma solidity ^0.6.2;
import "./Evaluator.sol";
import "./DummyToken.sol";

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AntoineRevel_SolutionTest {
    Evaluator evaluator;
    ERC20 tdToken;
    IExerciceSolution solution;
    bool isStarted;

    IUniswapV2Router02 uniswapRouter;
    DummyToken dummyToken;
    IERC20 private weth;


    constructor(IExerciceSolution _solution, Evaluator _evaluator,address _uniswapRouterAddress,DummyToken _dummyToken,address _tdToken) public{
        evaluator = _evaluator;
        tdToken=ERC20(_tdToken);
        solution = _solution;
        isStarted=false;
        uniswapRouter=IUniswapV2Router02(_uniswapRouterAddress);
        dummyToken=_dummyToken;
        weth=IERC20(uniswapRouter.WETH());
    }

    function startClaimPoint() public {
        require(!isStarted,"Already started !");
        isStarted=true;

        evaluator.ex1_showIHaveTokens();
        //evaluator.submitExercice(solution);
    }

    function buyToken() public payable {

        address [] memory path  = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1]= address(dummyToken);
        uint256[] memory amounts = uniswapRouter.swapExactETHForTokens{ value: msg.value }(0, path, address(this), block.timestamp + 15);

    }


    function getPoint() public view returns (uint256){
        return tdToken.balanceOf(address(this));
    }

    function getFactory() public view returns (address){
        return uniswapRouter.factory();
    }

    receive() external payable {}
}
