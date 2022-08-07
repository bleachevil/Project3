pragma solidity ^0.5.0;

import "./RoscaToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/access/Roles.sol";

// Have the RoscaTokenCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract RoscaTokenCrowdsale is Crowdsale, MintedCrowdsale { // UPDATE THE CONTRACT SIGNATURE TO ADD INHERITANCE
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(uint rate, address payable wallet, RoscaToken token)
        
    Crowdsale(rate, wallet, token) public {
        // constructor can stay empty
    }

    // What's the purpose of this?
    function deposit() public payable {
        //Need to know the contract address to deposit the ether?
        //This is different from the token addrees

    }

    function trade() public payable {
        //should take uint
        //ensure that uint < the tokens in the wallet
        //increase the eth in the wallet
        
    }

    

    uint256 public contractBalance = address(msg.sender).balance;


} //end

contract RoscaTokenCrowdsaleDeployer {
    
    address public rosca_token_address;
    address public rosca_crowdsale_address;

    constructor(string memory name, string memory symbol, address payable wallet) public {
        
        RoscaToken token = new RoscaToken(name, symbol, 0);
        rosca_token_address = address(token);

        RoscaTokenCrowdsale rosca_crowdsale = new RoscaTokenCrowdsale(10, wallet, token);
        rosca_crowdsale_address = address(rosca_crowdsale);

        // Set the `RoscaTokenCrowdsale` contract as a minter
        token.addMinter(rosca_crowdsale_address);
       
        // Have the `RoscaTokenCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }

}