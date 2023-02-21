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

    IUniswapV2Router02 uniswapRouter;
    IUniswapV2Factory public uniswapV2Factory;

    address dummyTokenAddress;
    DummyToken private dummyToken;

    address wethAddress;
    IERC20 private weth;

    address tokenToSwapAddress;
    IRichERC20 private tokenToSwap;


    constructor(address payable _evaluator,address _uniswapRouterAddress,address _dummyToken,address _tdToken) public payable {
        evaluator = Evaluator(_evaluator);
        tdToken=ERC20(_tdToken);

        uniswapRouter=IUniswapV2Router02(_uniswapRouterAddress);
        uniswapV2Factory=IUniswapV2Factory(uniswapRouter.factory());
        dummyTokenAddress=_dummyToken;
        dummyToken=DummyToken(_dummyToken);
        wethAddress=uniswapRouter.WETH();
        weth=ERC20(wethAddress);

        start();
    }

    function start() private {
        ex1_buyToken();
        ex2_addLiquidity();
        evaluator.ex6a_getTickerAndSupply();
    }

    function ex1_buyToken() private {
        address [] memory path  = new address[](2);
        path[0] = wethAddress;
        path[1]= dummyTokenAddress;
        uniswapRouter.swapExactETHForTokens{ value: msg.value/2 }(0, path, address(this), block.timestamp + 15);
        evaluator.ex1_showIHaveTokens();
    }

    function ex2_addLiquidity() private {
        uint256 balanceDT=dummyToken.balanceOf(address(this));
        require(dummyToken.approve(address(uniswapRouter), balanceDT),"token approved failed");
        uniswapRouter.addLiquidityETH{ value: msg.value/2 }(dummyTokenAddress,balanceDT,0,0,address(this),block.timestamp + 15);
        evaluator.ex2_showIProvidedLiquidity();
    }

    function continueClaim(address _ttsAddress,address solution) external payable{
        tokenToSwapAddress=_ttsAddress;
        tokenToSwap=IRichERC20(_ttsAddress);

        evaluator.submitErc20(tokenToSwap);

        evaluator.ex6b_testErc20TickerAndSupply();
        ex7_TradableOnUniswap();

        evaluator.submitExercice(IExerciceSolution(solution));
        evaluator.ex8_contractCanSwapVsEth();
    }

    function ex7_TradableOnUniswap() private{
        uint256 balanceTTS=tokenToSwap.balanceOf(address(this));
        require(tokenToSwap.approve(address(uniswapRouter), balanceTTS),"token approved failed");
        uniswapRouter.addLiquidityETH{ value: msg.value }(tokenToSwapAddress,balanceTTS,0,0,address(this),block.timestamp + 15);
        evaluator.ex7_tokenIsTradableOnUniswap();
    }

    function getPoint() public view returns (uint256){
        return tdToken.balanceOf(address(this));
    }

    function getSupply() public view returns (uint256){
        return evaluator.readSupply(address(this));
    }

    function getTicker() public view returns (string memory){
        return evaluator.readTicker(address(this));
    }

}
