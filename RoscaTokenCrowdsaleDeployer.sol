pragma solidity ^0.5.0;

import "./RoscaTokenCrowdsale.sol";

contract RoscaTokenCrowdsaleDeployer {
    
    address public rosca_token_address;
    address public rosca_crowdsale_address;

    constructor(string memory name, 
                string memory symbol, 
                address payable wallet
    ) public {
        
        RoscaToken token = new RoscaToken(name, symbol, 0);
        rosca_token_address = address(token); //deployed rosca token contract

        RoscaTokenCrowdsale rosca_crowdsale = new RoscaTokenCrowdsale(10, wallet, token, now, now+10 minutes);
        rosca_crowdsale_address = address(rosca_crowdsale); //deployed crowdsale

        // Set the `RoscaTokenCrowdsale` contract as a minter
        token.addMinter(rosca_crowdsale_address);
       
        // Have the `RoscaTokenCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }

}