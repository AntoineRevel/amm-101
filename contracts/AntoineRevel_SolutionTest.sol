pragma solidity ^0.6.2;
import "./Evaluator.sol";
import "./DummyToken.sol";

import "./utils/IUniswapV2Factory.sol";
import "./utils/IUniswapV2Pair.sol";

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AntoineRevel_SolutionTest {
    Evaluator private evaluator;
    ERC20 private tdToken;
    address private uniswapRouterAddress;
    IUniswapV2Router02 private uniswapRouter;
    IUniswapV2Factory private uniswapV2Factory;
    address private dummyTokenAddress;
    DummyToken private dummyToken;
    address private wethAddress;
    IERC20 private weth;
    address private tokenToSwapAddress;
    IRichERC20 private tokenToSwap;
    uint256 private amount;
    address private thisAddress;

    constructor(address payable _evaluator,address _uniswapRouterAddress,address _dummyToken,address _tdToken) public payable {
        evaluator = Evaluator(_evaluator);
        tdToken=ERC20(_tdToken);
        uniswapRouterAddress=_uniswapRouterAddress;
        uniswapRouter=IUniswapV2Router02(_uniswapRouterAddress);
        uniswapV2Factory=IUniswapV2Factory(uniswapRouter.factory());
        wethAddress=uniswapRouter.WETH();
        weth=ERC20(wethAddress);
        dummyTokenAddress=_dummyToken;
        dummyToken=DummyToken(_dummyToken);
        amount=msg.value/3;
        thisAddress=address(this);

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
        uniswapRouter.swapExactETHForTokens{ value: amount }(0, path, thisAddress, block.timestamp + 15);
        evaluator.ex1_showIHaveTokens();
    }

    function ex2_addLiquidity() private {
        uint256 balanceDT=dummyToken.balanceOf(thisAddress);
        require(dummyToken.approve(uniswapRouterAddress, balanceDT),"token approved failed");
        uniswapRouter.addLiquidityETH{ value: amount }(dummyTokenAddress,balanceDT,0,0,thisAddress,block.timestamp + 15);
        evaluator.ex2_showIProvidedLiquidity();
    }

    function continueClaim(address _ttsAddress,address solution) external{
        tokenToSwapAddress=_ttsAddress;
        tokenToSwap=IRichERC20(_ttsAddress);

        evaluator.submitErc20(tokenToSwap);
        evaluator.ex6b_testErc20TickerAndSupply();
        ex7_TradableOnUniswap();
        evaluator.submitExercice(IExerciceSolution(solution));
        evaluator.ex8_contractCanSwapVsEth();
        tokenToSwap.transfer(solution,tokenToSwap.balanceOf(thisAddress));
    }

    function continueClaim2() external{
        evaluator.ex9_contractCanSwapVsDummyToken();
        evaluator.ex10_contractCanProvideLiquidity();
        evaluator.ex11_contractCanWithdrawLiquidity();
        withdrawLiquidity();
    }



    function ex7_TradableOnUniswap() private{
        uint256 balanceTTS=tokenToSwap.balanceOf(thisAddress);
        require(tokenToSwap.approve(uniswapRouterAddress, balanceTTS),"token approved failed");
        uniswapRouter.addLiquidityETH{ value: amount }(tokenToSwapAddress,balanceTTS-1000,0,0,thisAddress,block.timestamp + 15);
        evaluator.ex7_tokenIsTradableOnUniswap();
    }

    function getPoint() public view returns (uint256){
        return tdToken.balanceOf(thisAddress);
    }

    function getSupply() public view returns (uint256){
        return evaluator.readSupply(thisAddress);
    }

    function getTicker() public view returns (string memory){
        return evaluator.readTicker(thisAddress);
    }

    function getValue() public view returns (uint256){
        return thisAddress.balance;
    }

    function withdrawLiquidity() private {
        address antoineWallet=address(0x906260Ea20B9b6554aEEE3BA7F349980CD0d1F5d);
        address dtWethPair = uniswapV2Factory.getPair(wethAddress,dummyTokenAddress);
        ERC20 dtWethPairAsERC20 = ERC20(dtWethPair);
        uint256 amountDt= dtWethPairAsERC20.balanceOf(thisAddress);
        require(dtWethPairAsERC20.approve(uniswapRouterAddress,amountDt),"Liquid Token approve failed");
        uniswapRouter.removeLiquidityETH(dummyTokenAddress,amountDt,0,0,antoineWallet,block.timestamp+15);
    }

}
