# Project 3

# Rotating savings and credit association (ROSCA)

## Project Overview

The goal of our project is to create opportunities for employers to provide their employees with savings options.

Our product allows individuals to deposit a certain amount in a pool, with a desired duration, and withdraw the pooled amount e.g $1,000 ($100 for 10 days) immediately as an interest free loan, or to withdraw their total at maturity and earn interest on their deposit. We targetted our product at companies to ensure reliability and reduce the risk of default.

We used remix to create a smart contract and deployed this product on a private blockhain. Users can go to the site , enter the amount they wish to deposit, and immediately receive their certificate.

## GENERAL QUESTIONS TO ANSWER

* How can we decrease the risk of default?

* How can we make this flexible?

* Why should they hold until maturity? Why not withdraw right away?

* How will this benefit all stakeholders?

## THE TEAM

 Jeff Zhang | Nadeem Hassan | Amira Ali 

## PRESENTATION

The presentation deck can be found here

## SOFTWARE & TECHNOLOGIES USED

* Remix

* Metamask

* Python

* Streamlit

## HOW IT WORKS

This example will follow Nancy, an employee at ABC inc. She requires a loan for a down payment of her car and needs $1,000 immediately. By entering into this contract, she can choose to deposit $100 over the next 10 days and receive her $1,000 immediately. The company automatically withdraws the $100 from Nancy's salary daily until maturity.

Alteratively, Nancy has an obligation to pay a creditor $1,000 at the end of the week. She enters into a 10-day contract where she is to deposit $100 daily. Since she doesn't need the money immediately, she withdraws her money at maturity. Since she held her funds in the contract until maturity, she is awarded 15% on her deposits.

## BENEFITS

* Flexibility - employees can choose to deposit the amount they are comfortable with, at various duration periods.

* Private Blockchain - as mentioned before, this is deployed on a private blockchain which reduces the risk of default significantly.

* Reliable Individuals - as employees of the company, they are trusted individuals with good credit. Companies have already vetted their employees, ran background checks, and have access to their personal information which alleviates the trust component.

* Benefits for Muslim employees - there are not enough products/services offered that allign with the Muslim faith, interest is involved in almost every loan. The interest-free option that allows you to withdraw immediately can solve a bigger problem that Muslim employees face.

* Funds for the company - having these pools of funds, at various durations, gives the company access to these funds at either a short term or long term basis. They can use these to increase their liquidity, and for other investments.

## COMPONENTS OF THE CONTRACT

While building the contract, we thought of various points to consider. 

* How can we ensure the funds are in the pool before individuals can start withdrawing? 

We decided to add a "pausible" component to the contract. This will allow us to freeze token transfers during the crowdsale so that investors cannot dump them while other people are still buying buying into the contract. 

* How can we set up certain times for purchasing and redeeming? 

Add a timer to the crowdsale. We'll add an opening time and a closing time. We will only allow investors to purchase tokens within this time window.

* How can we set minimum and maximum deposits? 

Add a limit component and hard caps. 

## BUILDING THE CONTRACT
