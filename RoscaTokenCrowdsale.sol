pragma solidity ^0.5.0;

import "./RoscaToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/access/Roles.sol";

contract RoscaTokenCrowdsale is Crowdsale, 
                                MintedCrowdsale, 
                                TimedCrowdsale {

    constructor(uint rate, 
                address payable wallet, 
                RoscaToken token, 
                uint256 openingTime, 
                uint256 closingTime
    )    
    Crowdsale(rate, wallet, token) 
    TimedCrowdsale(openingTime, closingTime)
    public {
    }

    function deposit() public payable {}

    function getBalance(address wallet) public view returns(uint256) {
        return address(wallet).balance;
    }

    uint256 private _weiRaised;
    
    function buyTokens(address beneficiary) public nonReentrant payable {
        uint256 weiAmount = msg.value;
        _preValidatePurchase(beneficiary, weiAmount);

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(weiAmount);

        // update state
        _weiRaised = _weiRaised.add(weiAmount);

        _processPurchase(beneficiary, tokens);
        emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);

        _updatePurchasingState(beneficiary, weiAmount);
    }

    /*    
    function trade() public payable {
        //should take uint
        //ensure that uint < the tokens in the wallet
        //increase the eth in the wallet
        address()this    
    }

    */

} //end