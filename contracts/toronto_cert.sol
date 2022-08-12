
// SPDX-License-Identifier: University of Toronto
pragma solidity ^0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";    
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Toronto_Certificate is ERC721Enumerable, Ownable {
    using Strings for uint256;

    mapping (uint256 => string) private _tokenURIs;

    constructor(string memory _name, string memory _symbol) ERC721(_name,_symbol)
    { }

    function _setTokenURI(uint256 tokenID, string memory _tokenURI) internal{
        require(_exists(tokenID), "Token ID does not exist to add URI");
        _tokenURIs[tokenID] = _tokenURI;
    }

    function mint(address recipient, string memory nftURI) external onlyOwner(){
        //Add require to prevent dulicate URIs
        uint256 tokenID = totalSupply();
        _mint(recipient,tokenID);
        _setTokenURI(tokenID,nftURI);
    }

    function tokenURI(uint256 tokenID) public view virtual override returns(string memory){
        require(_exists(tokenID), "Token ID does not exist");
        string memory _tokenURI = _tokenURIs[tokenID];
        return _tokenURI;
    }


}