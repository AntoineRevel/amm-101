pragma solidity ^0.6.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenToSwap is ERC20 {
    constructor(string memory _ticker, uint256 _supply, address addressToMint) ERC20("Token To Swap", _ticker) public{
        _mint(addressToMint, _supply);
    }

}
