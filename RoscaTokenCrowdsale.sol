pragma solidity ^0.5.0;

import "./RoscaToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/WhitelistCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundableCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/access/Roles.sol";

contract RoscaTokenCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, WhitelistCrowdsale, RefundableCrowdsale {

    // Track investor contributions
    uint256 public investorMinCap =  2000000000000000; // 0.002 ether
    uint256 public investorHardCap = 50000000000000000000; // 50 ether
    mapping(address => uint256) public contributions;

    constructor(uint rate, 
                address payable wallet, 
                RoscaToken token, 
                uint256 cap, 
                uint256 openingTime, 
                uint256 closingTime, 
                uint256 goal
    )    
    Crowdsale(rate, wallet, token) 
    CappedCrowdsale(cap)
    TimedCrowdsale(openingTime, closingTime)
    RefundableCrowdsale(goal)
    public {
        require(goal <= cap);
    }

    /**
    * @dev Returns the amount contributed so far by a sepecific user.
    * @param _beneficiary Address of contributor
    * @return User contribution so far
    */
    
    function getUserContribution(address _beneficiary) public view returns (uint256) {
        return contributions[_beneficiary];
    }

    /**
    * @dev Extend parent behavior requiring purchase to respect investor min/max funding cap.
    * @param _beneficiary Token purchaser
    * @param _weiAmount Amount of wei contributed
    */

    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
        super._preValidatePurchase(_beneficiary, _weiAmount);
        //uint256 _existingContribution = contributions[_beneficiary];
        //uint256 _newContribution = _existingContribution.add(_weiAmount);
        //require(_newContribution >= investorMinCap && _newContribution <= investorHardCap);
        //contributions[_beneficiary] = _newContribution;
    }

 
} //end



   /*

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

    */

    

    //uint256 public contractBalance = address(msg.sender).balance;



