pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Pausable.sol";


// Create a constructor for the RoscaToken contract and have the contract inherit the libraries from OpenZeppelin.
// First, we want to make the token "mintable", which means we want to be able to create new tokens. 
// This will allow us to create new tokens in the crowdsale, instead of having a fixed total supply from the beginning.
// Next, we want to make our token "pausable". 
// This will allow us to freeze token transfers during the crowdsale so that investors cannot dump them while other people are still buying them.

contract RoscaToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Pausable {
    constructor(string memory name, 
                string memory symbol, 
                uint total_supply //needed if minting initial supply in the mint() function below
    ) // RoscaToken Constructor
    
    // ERC20Detailed constructor...
    // If 0 -- 1 Ether for 1 token
    // If 18 - 1 Wei for 1 token
    ERC20Detailed(name, symbol, 0) public {
        // If initial supply is required
        // mint(msg.sender, total_supply);
    }

} //end contract