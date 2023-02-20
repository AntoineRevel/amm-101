pragma solidity ^0.6.2;
import "./Evaluator.sol";
import "./DummyToken.sol";

import "./utils/IUniswapV2Factory.sol";
import "./utils/IUniswapV2Pair.sol";

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AntoineRevel_SolutionTest {
    Evaluator evaluator;
    ERC20 tdToken;
    IExerciceSolution solution;


    IUniswapV2Router02 uniswapRouter;
    IUniswapV2Factory public uniswapV2Factory;

    address dummyTokenAddress;
    DummyToken private dummyToken;

    address wethAddress;
    IERC20 private weth;

    constructor(IExerciceSolution _solution, address payable _evaluator,address _uniswapRouterAddress,address _dummyToken,address _tdToken) public{
        evaluator = Evaluator(_evaluator);
        tdToken=ERC20(_tdToken);
        solution = _solution;
        uniswapRouter=IUniswapV2Router02(_uniswapRouterAddress);
        uniswapV2Factory=IUniswapV2Factory(uniswapRouter.factory());
        dummyTokenAddress=_dummyToken;
        dummyToken=DummyToken(_dummyToken);
        wethAddress=uniswapRouter.WETH();
        weth=ERC20(wethAddress);
    }

    function start() external payable {
        buyTokenEx1();
        addLiquidityEx2();
    }

    function buyTokenEx1() private {
        address [] memory path  = new address[](2);
        path[0] = wethAddress;
        path[1]= dummyTokenAddress;
        uniswapRouter.swapExactETHForTokens{ value: msg.value/2 }(0, path, address(this), block.timestamp + 15);
        evaluator.ex1_showIHaveTokens();
    }

    function addLiquidityEx2() private {
        uint256 balanceDT=dummyToken.balanceOf(address(this));
        require(dummyToken.approve(address(uniswapRouter), balanceDT),"token approved failed");
        uniswapRouter.addLiquidityETH{ value: msg.value/2 }(dummyTokenAddress,balanceDT,0,0,address(this),block.timestamp + 15);
        evaluator.ex2_showIProvidedLiquidity();
    }



    function getPoint() public view returns (uint256){
        return tdToken.balanceOf(address(this));
    }


    receive() external payable {}
}
