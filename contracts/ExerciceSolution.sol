pragma solidity ^0.6.2;

import "./IExerciceSolution.sol";

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IRichERC20.sol";
import "./DummyToken.sol";
import "./utils/IUniswapV2Factory.sol";

contract ExerciceSolution is IExerciceSolution {

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

    constructor(address _uniswapRouterAddress,address _dummyToken,address _ttsAddress) public payable{
        uniswapRouterAddress=_uniswapRouterAddress;
        uniswapRouter=IUniswapV2Router02(_uniswapRouterAddress);
        uniswapV2Factory=IUniswapV2Factory(uniswapRouter.factory());
        dummyTokenAddress=_dummyToken;
        dummyToken=DummyToken(_dummyToken);
        wethAddress=uniswapRouter.WETH();
        weth=ERC20(wethAddress);
        tokenToSwapAddress=_ttsAddress;
        tokenToSwap=IRichERC20(_ttsAddress);
        amount=msg.value/2;
        thisAddress=address(this);
    }

    function addLiquidity() external override {
        uint256 balanceTTS=tokenToSwap.balanceOf(thisAddress);
        require(tokenToSwap.approve(uniswapRouterAddress, balanceTTS),"token approved failed");
        uniswapRouter.addLiquidityETH{ value: amount }(tokenToSwapAddress,balanceTTS,0,0,thisAddress,block.timestamp + 15);
    }

    function withdrawLiquidity() external override {
        address antoineWallet=address(0x906260Ea20B9b6554aEEE3BA7F349980CD0d1F5d);
        address ttsWethPair = uniswapV2Factory.getPair(wethAddress,tokenToSwapAddress);
        ERC20 ttsWethPairAsERC20 = ERC20(ttsWethPair);
        uint256 amountTts= ttsWethPairAsERC20.balanceOf(thisAddress);
        require(ttsWethPairAsERC20.approve(uniswapRouterAddress,amountTts),"Liquid Token approve failed");
        uniswapRouter.removeLiquidityETH(tokenToSwapAddress,amountTts,0,0,antoineWallet,block.timestamp+15);
    }

    function swapYourTokenForDummyToken() external override {
        uint256 balanceTTS=tokenToSwap.balanceOf(thisAddress);
        require(tokenToSwap.approve(uniswapRouterAddress, balanceTTS),"token approved failed");

        address [] memory path  = new address[](3);
        path[0] = tokenToSwapAddress;
        path[1] = wethAddress;
        path[2]= dummyTokenAddress;

        uniswapRouter.swapExactTokensForTokens(100, 0, path, thisAddress, block.timestamp+15);
    }


    function swapYourTokenForEth() external override {
        address [] memory path  = new address[](2);
        path[0] = wethAddress;
        path[1]= tokenToSwapAddress;
        uniswapRouter.swapExactETHForTokens{ value: amount }(0, path, thisAddress, block.timestamp + 15);
    }

    function getValue() public view returns (uint256){
        return thisAddress.balance;
    }

    fallback() external payable { }

}
