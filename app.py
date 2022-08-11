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
from datetime import date, timedelta

load_dotenv()

# Create a W3 Connection
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))
private_key = os.getenv("PRIVATE_KEY")
contract_address = os.getenv("SMART_CONTRACT_ADDRESS_NFT")

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

account = generate_account(w3, private_key)
st.write("Load Account Address: ", account.address)
st.write("Smart Contract Address: ", contract_address)

st.header("JOIN NOW!")
deposit_amounts = [100,200,300,400,500,600,700,800,900,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000]
duration_options = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
deposits = st.selectbox("How much would you like to deposit?",deposit_amounts)
duration= st.selectbox("How long would you like to deposit this for?" , duration_options)

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

student_account = st.text_input("Enter Employee's Account Address: ", value="0x0d9Ea39777C2741f2D57dB89aA6e9749728573Bb")

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
## Streamlit Inputs
######################################################################
st.markdown("## Create the Certificate")

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
    
    nonce = w3.eth.get_transaction_count(account.address)

    # THIS ONLY WORKS IN GANACHE
    tx = contract.functions.mint(student_account,cert_uri).buildTransaction({
        'chainId':4,
        'gas': 20000000,
        'nonce': nonce
    })
    
    st.write("Raw TX ", tx)
    
    signed_tx = account.sign_transaction(tx)
    
    st.write("Signed TX Hash: ", signed_tx.rawTransaction)
    
    tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
    
    # This generally works on the mainnet - Rinkeby, not so much
    #receipt = w3.eth.waitForTransactionReceipt(tx_hash)      

    st.write("Transaction mined")
    #st.write(dict(receipt))

    st.write("You can view the pinned metadata file with the following IPFS Gateway Link")
    st.markdown(f"[Cert IPFS Gateway Link] (https://{cert_uri})")
    st.markdown(f"[Cert IPFS Image Link] (https://{token_json['image']})")
    
    
    # add purchase
    tx_cs = contract_cs.functions.buyTokens(student_account).buildTransaction({
        'chainId':4,
        'gas': 20000000,
        'value': w3.toWei(deposits,"ether"),
        'nonce': nonce
    })
    
    st.write("Raw TX ", tx_cs)
    
    signed_tx_cs = account.sign_transaction(tx_cs)
    
    st.write("Signed TX Hash: ", signed_tx_cs.rawTransaction)
    