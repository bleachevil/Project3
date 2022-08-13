# Project 3

# Rotating savings and credit association (ROSCA)

## Project Overview

The goal of our project is to create opportunities for employers to provide their employees with savings options.

Our product allows individuals to deposit a certain amount in a pool, with a desired duration, and withdraw the pooled amount e.g $100 ($10 for 10 days) immediately as an interest free loan, or to withdraw their total at maturity and earn interest on their deposit. We targetted our product at companies to ensure reliability and reduce the risk of default.

We used remix to create a smart contract and deployed this product on a private blockhain. Users can go to the site , enter the amount they wish to deposit, and immediately receive their certificate.
Whenever they wish to redeem, users can go to the same site and receive a certificate with their tokens, and exchange that for ether. The interface is user friendly and interactive.

## GENERAL QUESTIONS TO ANSWER

* How can we decrease the risk of default?

* How can we make this flexible?

* Why should they hold until maturity? Why not withdraw right away?

* How will this benefit all stakeholders?

## THE TEAM

 Jeff Zhang | Nadeem Hassan | Amira Ali 

## PRESENTATION

The presentation deck can be found `here`

## SOFTWARE & TECHNOLOGIES USED

* Remix

* Metamask

* Python

* Streamlit

## HOW IT WORKS

This example will follow Nancy, an employee at ABC inc. She requires a loan for a down payment of her car and needs $100 immediately. By entering into this contract, she can choose to deposit $10 over the next 10 days and receive her $100 immediately. The company automatically withdraws the $10 from Nancy's salary daily until maturity.

Alteratively, Nancy has an obligation to pay a creditor $100 at the end of the week. She enters into a 10-day contract where she is to deposit $10 daily. Since she doesn't need the money immediately, she withdraws her money at maturity. Since she held her funds in the contract until maturity, she is awarded 20% on her deposits.

## BENEFITS

* Flexibility - employees can choose to deposit the amount they are comfortable with, at various duration periods.

* Private Blockchain - as mentioned before, this is deployed on a private blockchain which reduces the risk of default significantly.

* Reliable Individuals - as employees of the company, they are trusted individuals with good credit. Companies have already vetted their employees, ran background checks, and have access to their personal information which alleviates the trust component.

* Benefits for Muslim employees - there are not enough products/services offered that allign with the Muslim faith, interest is involved in almost every loan. The interest-free option that allows you to withdraw immediately can solve a bigger problem that Muslim employees face.

* Funds for the company - having these pools of funds, at various durations, gives the company access to these funds at either a short term or long term basis. They can use these to increase their liquidity, and for other investments.

* Employee benefits - depending on the company, these tokens could potentially be traded in for vacation days ( if they have a balance at maturtity and wish not to redeem)

## COMPONENTS OF THE CONTRACT

While building the contract, we thought of various points to consider. 

* How can we ensure the funds are in the pool before individuals can start withdrawing? 

We decided to add a "pausible" component to the contract. This will allow us to freeze token transfers during the crowdsale so that investors cannot dump them while other people are still buying buying into the contract. 

* How can we set up certain times for purchasing and redeeming? 

Add a timer to the crowdsale. We'll add an opening time and a closing time. We will only allow investors to purchase tokens within this time window.

## BUILDING THE CONTRACT

### ROSCATOKEN.SOL

For [this](https://github.com/bleachevil/Project3/blob/e07ee16a9acb4a7af504839a8b2cb082b6327c5a/RoscaToken.sol)  contract, we inherited ERC20, ERC20Detailed, ERC20Mintable, and ERC20Pausible from Open Zeppelin.

We constructed a contract that takes in the name of the token, the symbol, and total supply. 

```` 
contract RoscaToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Pausable {
    constructor(string memory name, 
                string memory symbol, 
                uint total_supply //needed if minting initial supply in the mint() function below
    )
    
````

For the detailed constructor, we set the multilplier to 18 to represent 1 wei per token. 


### ROSCATOKENCROWDSALE.SOL

[This](https://github.com/bleachevil/Project3/blob/e07ee16a9acb4a7af504839a8b2cb082b6327c5a/RoscaTokenCrowdsale.sol) contract inherits crowdsale, minted corwdsale, timedcrowdsale, capped crowdsale, and RefundablePostDeliveryCrowdsale from Open Zeppelin. 

We mapped the address to the contribution amounts, as well as the balances. 

The crowdsale function takes in the rate, wallet, and token. The timed crowdsale requires an opening time and closing time, which we set as `10 minutes` past the opening time. We can also set the goal of the crowdsale to which ever number, and if the goal is not reached, the contributors will have their deposits refunded. If the goal is reached, they are locked into the contract. 

The sendViaTransfers function takes in an address. If a contributor wishes to redeem, their address is entered into the function. When we call the function , the tokens get sent back to the contract. Which then get sent to the contributer. 


### ROSCATOKENCROWDSALEDEVELOPER.SOL

[This](https://github.com/bleachevil/Project3/blob/e2af4a4a3633f660518d95bfab73c6c6427bbbd8/RoscaTokenCrowdsaleDeployer.sol) contract takes in a name, symbol, and wallet address. 

We set the crowdsale contract as the minter, and have it renounce its minter role to demonstrate that we are no longer accepting new tokens.

````
        token.addMinter(rosca_crowdsale_address);
        token.renounceMinter();
        
 ````
 


## USER INTERFACE

On the user's end, they will see our streamlit interface where they enter their name, wallet address, desired duration, deposit amount, as well as the start/end date. Once they submit, they will receive a certificate with their deposit amount that they can cash in when they choose.

<img width="940" alt="Screen Shot 2022-08-13 at 8 25 45 AM" src="https://user-images.githubusercontent.com/99091066/184493963-8f3ce547-1c1a-437b-8a8e-282539285090.png">

<img width="821" alt="Screen Shot 2022-08-13 at 8 26 01 AM" src="https://user-images.githubusercontent.com/99091066/184493970-f6ccfdb7-f66e-4b48-b85f-0f229d8f68af.png">


The same process is valid for redemptions. Here, the user can enter their wallet address and check their balance. Then, they enter in their balance amount and withdraw their funds. 

<img width="1001" alt="Screen Shot 2022-08-13 at 8 27 30 AM" src="https://user-images.githubusercontent.com/99091066/184494025-97116dc0-1338-4352-aa31-2e25e8cbd55f.png">


## CONCLUSION


Our project has several use cases and could benefit emoloyers and their employees. Version 1 of this project explores the basic ins and outs of the process : ensuring tokens are available for purchase, updating their unit balances, and withdrawing the tokens for ether, all while providing the employee a user friendly interface.

We believe this solves a problem that many individuals face. Both parties, the employee and the employer, would benefit from this arrangement and thus, we are certain companies would be eager to implement our product.
 
### GOING FORWARD 

 If we were not constrained by time, we would have explored several other features. 


1) Deposit on a rolling basis

Instead of having a crowdsale period that is then locked for the duration, we could consider having an employee deposit whenever they want to, removing the time constraints.

2) Whitelist features 

For example only full time employees are eligible for contributions.

3) Have variable interest

Right now, interest is fixed at 20%, we could add a feature that allows for higher rates that can be distributed by the company if they have a good ROI using the crowdsale funding.







