pragma solidity ^0.5.0;

import "./RoscaTokenCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/access/Roles.sol";

contract RoscaTokenCrowdsaleDeployer {
    
    address public rosca_token_address;
    address public rosca_crowdsale_address;

    constructor(string memory name, 
                string memory symbol, 
                address payable wallet
    ) public {
        
        RoscaToken token = new RoscaToken(name, symbol, 0);
        rosca_token_address = address(token); //deployed rosca token contract

        //cap = 10 ether
        //goal = 5 ether
        //openingTime = now
        //closingTime = 1 mins after

        RoscaTokenCrowdsale rosca_crowdsale = new RoscaTokenCrowdsale(10, wallet, token, 10000000000000000000, now, now + 1 minutes, 5000000000000000000);
        rosca_crowdsale_address = address(rosca_crowdsale); //deployed crowdsale

        // Set the `RoscaTokenCrowdsale` contract as a minter
        token.addMinter(rosca_crowdsale_address);
       
        // Have the `RoscaTokenCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }

}