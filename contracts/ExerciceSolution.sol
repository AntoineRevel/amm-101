pragma solidity ^0.6.2;

import "./IExerciceSolution.sol";

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IRichERC20.sol";
import "./DummyToken.sol";
import "./utils/IUniswapV2Factory.sol";

contract ExerciceSolution is IExerciceSolution {
    IUniswapV2Router02 uniswapRouter;
    IUniswapV2Factory public uniswapV2Factory;

    address dummyTokenAddress;
    DummyToken private dummyToken;

    address wethAddress;
    IERC20 private weth;

    address tokenToSwapAddress;
    IRichERC20 private tokenToSwap;


    constructor(address _uniswapRouterAddress,address _dummyToken,address _ttsAddress) public payable{
        uniswapRouter=IUniswapV2Router02(_uniswapRouterAddress);
        uniswapV2Factory=IUniswapV2Factory(uniswapRouter.factory());
        dummyTokenAddress=_dummyToken;
        dummyToken=DummyToken(_dummyToken);
        wethAddress=uniswapRouter.WETH();
        weth=ERC20(wethAddress);
        tokenToSwapAddress=_ttsAddress;
        tokenToSwap=IRichERC20(_ttsAddress);

    }

    function addLiquidity() external override {}

    function withdrawLiquidity() external override {}

    function swapYourTokenForDummyToken() external override {
        //buyTts();
        uint256 balanceTTS=tokenToSwap.balanceOf(address(this));
        require(tokenToSwap.approve(address(uniswapRouter), balanceTTS),"token approved failed");

        address [] memory path  = new address[](3);
        path[0] = tokenToSwapAddress;
        path[1] = wethAddress;
        path[2]= dummyTokenAddress;

        uniswapRouter.swapExactTokensForTokens(10, 0, path, address(this), block.timestamp+15);
    }

    function buyTts() private{
        address [] memory path  = new address[](2);
        path[0] = wethAddress;
        path[1]= tokenToSwapAddress;
        uniswapRouter.swapExactETHForTokens{ value: address(this).balance }(0, path, address(this), block.timestamp + 15);
    }

    function swapYourTokenForEth() external override {
        address [] memory path  = new address[](2);
        path[0] = wethAddress;
        path[1]= tokenToSwapAddress;
        uniswapRouter.swapExactETHForTokens{ value: address(this).balance }(0, path, address(this), block.timestamp + 15);
    }

    function getValue() public view returns (uint256){
        return address(this).balance;
    }
}
