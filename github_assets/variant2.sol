// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.8.3/utils/Counters.sol";
import "@openzeppelin/contracts@4.8.3/utils/cryptography/ECDSA.sol";


contract EXAMPLENFT is ERC721, Ownable {
   using Counters for Counters.Counter;

   Counters.Counter private _tokenIdCounter;

   // using ECDSA implementation by openzeppelin
   using ECDSA for bytes32;

   // address of a wallet we will compare signature owner with
   address private owner_ = 0x205D8006383Bd92785e29DDaf398D92c65EE7020;

   constructor() ERC721("EXAMPLENFT", "EXMP") {}

   function _baseURI() internal pure override returns (string memory) {
       return "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg";
   }

   /**
   * @dev simple NFT mint function
    * @param to an address to mint an NFT
    * @param messageHash message hash, needs to verify a message
    * @param r first 32 bytes
    * @param s second 32 bytes
    * @param v final byte
    */ 
   function safeMint(address to, bytes32 messageHash, bytes32 r, bytes32 s, uint8 v) public onlyOwner {
       require(verify_signer(messageHash, r, s, v), "You are not allowed to access this function");

       uint256 tokenId = _tokenIdCounter.current();
       _tokenIdCounter.increment();
       _safeMint(to, tokenId);
   }

   /**
   * @dev verifies an owner of a signature
    * @return bool
    */
   function verify_signer(bytes32 _messageHash, bytes32 r, bytes32 s, uint8 v) private view returns (bool){
       address signer = ECDSA.recover(_messageHash, v, r, s);

       require(signer != address(0), "ECDSA: invalid signature");

       if (signer == owner_) {
           return true;
       }

       return false;
   }
}