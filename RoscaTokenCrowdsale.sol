pragma solidity ^0.5.0;

import "./RoscaToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract RoscaTokenCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    // Track investor contributions
    //uint256 public investorMinCap =  2000000000000000000; // 2 ether
    //uint256 public investorHardCap = 5000000000000000000; // 5 ether
    mapping(address => uint256) public contributions;
    mapping(address => uint) balances;

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

    function balance() public view returns(uint) {
        return address(msg.sender).balance;
    }

    function sendViaTransfer(address payable _to) public payable {
        // This function is no longer recommended for sending Ether.
        uint256 balanced = balance();
        require(balanced > 0 && msg.value <= balanced, "Treasury is bankrupt");

        _to.transfer(msg.value);
    }
 
} //end