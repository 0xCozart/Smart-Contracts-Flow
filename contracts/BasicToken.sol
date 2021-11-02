// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzepplin/contracts/token/ERC20/ERC20.sol";

contract BasicToken is ERC20 {
    constructor(uint256 _initialSupply) public ERC20("Basic", "BSC") {
        _mint(msg.sender, _initialSupply);
    }
}
