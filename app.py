import os
import json
from web3 import Account
#from web3.gas_strategies.time_based import medium_gas_price_strategy
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st
import requests
import datetime as dt
from datetime import date, timedelta,datetime

load_dotenv()


# Create a W3 Connection
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))
private_key = os.getenv("PRIVATE_KEY")
private_key_test = os.getenv("TEST_PRIVATE_KEY")
contract_address = os.getenv("SMART_CONTRACT_ADDRESS_NFT")
contract_address_cs = os.getenv("SMART_CONTRACT_ADDRESS_CS")
contract_address_token = os.getenv("SMART_CONTRACT_ADDRESS_TOKEN")

def generate_account(w3,private_key):
    account = Account.privateKeyToAccount(private_key)
    return account
    

# Set up Pinata Headers
json_headers = {
    "Content-Type":"application/json",
    "pinata_api_key": os.getenv("PINATA_API_KEY"),
    "pinata_secret_api_key": os.getenv("PINATA_SECRET_API_KEY")
}

file_headers = {
    "pinata_api_key": os.getenv("PINATA_API_KEY"),
    "pinata_secret_api_key": os.getenv("PINATA_SECRET_API_KEY")
}

def convert_data_to_json(content):
    data = {"pinataOptions":{"cidVersion":1}, 
            "pinataContent":content }
    return json.dumps(data)

def pin_file_to_ipfs(data):
    r = requests.post("https://api.pinata.cloud/pinning/pinFileToIPFS",
                      files={'file':data},
                      headers= file_headers)
    print(r.json())
    ipfs_hash = r.json()["IpfsHash"]
    return ipfs_hash

def pin_json_to_ipfs(json):
    r = requests.post("https://api.pinata.cloud/pinning/pinJSONToIPFS",
                      data=json,
                      headers= json_headers)
    print(r.json())
    ipfs_hash = r.json()["IpfsHash"]
    return ipfs_hash

def pin_cert(cert_name, cert_file,**kwargs):
    # Pin certificate picture to IPFS
    ipfs_file_hash = pin_file_to_ipfs(cert_file)

    # Build our NFT Token JSON
    token_json = {
       "name": cert_name,
       "image": f"ipfs.io/ipfs/{ipfs_file_hash}"
    }

    # Add extra attributes if any passed in
    token_json.update(kwargs.items())

    # Add to pinata json to be uploaded to Pinata
    json_data = convert_data_to_json(token_json)

    # Pin the real NFT Token JSON
    json_ipfs_hash = pin_json_to_ipfs(json_data)

    return json_ipfs_hash, token_json

# Pull in Ethereum Account - Used for signing account

st.header("EMPLOYEE BENEFIT AT PRIVATE BLOCKCHAIN")

account = generate_account(w3, private_key)
account2 = generate_account(w3, private_key_test)
st.write("Owner's Address: ", account.address)
st.write("Smart Contract Address_NFT: ", contract_address)
st.write("Smart Contract Address_CROWDSALE: ", contract_address_cs)
st.write("Smart Contract Address_TOKEN: ", contract_address_token)



######################################################################
## Load the NFT contract
######################################################################

@st.cache(allow_output_mutation=True)
def load_contract():
    with open(Path("./contracts/complied/certificate_abi.json")) as file:
        certificate_abi = json.load(file)

    contract_address = os.getenv("SMART_CONTRACT_ADDRESS_NFT")

    cert_contract = w3.eth.contract(address=contract_address,
                    abi=certificate_abi)

    return cert_contract            

contract = load_contract()

student_account = st.text_input("Enter Employee's Account Address: ", value="0x02c99C24a118f29ec214E33c722Af42D24f7fAe6")

######################################################################
## Load the crowdsale contract
######################################################################

@st.cache(allow_output_mutation=True)
def load_contract_cs():
    with open(Path("./contracts/complied/crowdsale_abi.json")) as file:
        cs_abi = json.load(file)

    contract_address_cs = os.getenv("SMART_CONTRACT_ADDRESS_CS")

    cs_contract = w3.eth.contract(address=contract_address_cs,
                    abi=cs_abi)

    return cs_contract            

contract_cs = load_contract_cs()

######################################################################
## Load the token contract
######################################################################

@st.cache(allow_output_mutation=True)
def load_contract_token():
    with open(Path("./contracts/complied/token_abi.json")) as file:
        token_abi = json.load(file)

    contract_address_token = os.getenv("SMART_CONTRACT_ADDRESS_TOKEN")

    token_contract = w3.eth.contract(address=contract_address_token,
                    abi=token_abi)

    return token_contract            

contract_token = load_contract_token()

######################################################################
## Streamlit Headline
######################################################################

st.header("JOIN NOW!")

        
close_time = contract_cs.functions.closingTime().call()
#now_time = 
        
st.write("Close Time: ",  datetime.fromtimestamp(close_time))
        
deposit_amounts = [10,100,200,300,400,500,600,700,800,900,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000]
duration_options = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
deposits = st.selectbox("How much would you like to deposit?",deposit_amounts)
duration= st.selectbox("How long would you like to deposit this for?" , duration_options)

######################################################################
## Streamlit Inputs
######################################################################
st.markdown("## Create the Certificate and Get Token")

now_today = date.today()
td = timedelta(duration)

cert_name = st.text_input("Enter the name of a employee: ")
#university_name = st.text_input("Name of University: ", value="University of Toronto")
#class_name = st.text_input("Enter the class name: ", value="Fintech Bootcamp")
cert_start_date = st.text_input("Date of start: ", value=now_today)
cert_date = st.text_input("Date of completion: ", value= (now_today + td))
contribution = st.text_input("Total contribution: ", value = (deposits * duration))
cert_details = st.text_input("Certificate Details: ", value=f"Certificate of {deposits * duration} dollars")

# Upload the Certificate Picture File
#file = st.file_uploader("Upload a Certificate", type=["png","jpeg"])

# Add Certificate Picture File // convert it into a file

file = open("./picture/1000.jpg",'rb')

######################################################################
## Button to Award the Certificate
######################################################################

if st.button("Award Certificate and purchase Token"):

    cert_ipfs_hash,token_json = pin_cert(cert_name,file, data_of_start = cert_start_date, total_contribution = contribution,
            date_of_completion = cert_date, details=cert_details)

    cert_uri = f"ipfs.io/ipfs/{cert_ipfs_hash}"
    
    nonce = w3.eth.get_transaction_count(account2.address)

    # THIS ONLY WORKS IN GANACHE
    tx_hash = contract.functions.mint(student_account,cert_uri).transact({'from':student_account,'gas':1000000})
    # This generally works on the mainnet - Rinkeby, not so much
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)      

    st.write("Transaction mined")
    st.write(dict(receipt))

    st.write("You can view the pinned metadata file with the following IPFS Gateway Link")
    st.markdown(f"[Cert IPFS Gateway Link] (https://{cert_uri})")
    st.markdown(f"[Cert IPFS Image Link] (https://{token_json['image']})")
    
    
    # add purchase
        #nonce = w3.eth.get_transaction_count(account2.address)
    tx_cs = contract_cs.functions.buyTokens(student_account).transact({
        'from': student_account,
        'value': w3.toWei(deposits,"ether"),
    })
    
    receipt = w3.eth.waitForTransactionReceipt(tx_cs) 
    st.write("Transaction Done!")
    st.write(dict(receipt))
    
    
######################################################################
## Streamlit Inputs
######################################################################
st.markdown("## Withdraw and Claim!")

employee_account = st.text_input("Enter Employee's account Address: ", value="0x02c99C24a118f29ec214E33c722Af42D24f7fAe6")

if st.button("check holding"):
        check_balance = contract_cs.functions.balanceOf(employee_account).call()
        st.write("Holding ",w3.fromWei(check_balance,'ether'),"USD")

w_amount = st.text_input("Holdings: ", 100)

if st.button("withdraw"):
        withdraw_done = contract_cs.functions.withdrawTokens(employee_account).transact({
        'from': employee_account,
        #'value': w3.toWei(w_amount,"ether"),
        'nonce': w3.eth.get_transaction_count(account2.address)
        })
        receipt = w3.eth.waitForTransactionReceipt(withdraw_done) 
        st.write("Success & Transaction Complete!")
        st.write(dict(receipt))
        
