
// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";

// Create a constructor for the RoscaToken contract and have the contract inherit the libraries from OpenZeppelin.

contract RoscaToken is ERC20, ERC20Detailed, ERC20Mintable {
    constructor(string memory name, string memory symbol, uint initial_supply) // RoscaToken Constructor
    
    // ERC20Detailed constructor...0 indicates 1 Ether is 1 token
    ERC20Detailed(name, symbol, 0) public {
        // empty
        _mint(msg.sender, initial_supply);
    }

}