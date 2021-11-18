// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract MyCollectible is ERC721, Ownable {
    using Counters for Counters.Counter;

    mapping(address => uint) public ownerToTokenAmount;
    mapping(uint => address) public tokenToOwner;

    struct Legionaire {
        uint
    }

    Counters.counter public _tokenIdCounter;

    constructor() ERC721("Legion", "LGN") {
        _tokenIdCounter = 0;
    }

    function safeMint(uint _amount, string _cid) public {
        require(msg.value >= 0.069 ether, "Please send at least 0.069 ether (does not include gas)");
        require(!tokenToOwner[_tokenId]);

        _safemint(msg.value, _tokenIdCounter);
        _tokenIdCounter.increment();
    }

    function _safemint(uint _amount, uint _tokenId) private {
        ownerToTokenAmount[msg.sender] += _amount;
        tokenToOwner[_tokenId] = msg.sender;
    }

    function ownerToTokens(address _owner) public view returns (uint[]) {
        require(_owner != address(0));
        require(ownerToTokenAmount[_owner] != 0, "Address does not own any tokens");

        uint[] memory tokens;

        for(uint i = 0; tokens.length != ownerToTokenAmount[_owner] || i <= counter ; i++) {
            if(tokenToOwner[i] == _owner) {
                tokens.push(i);
            }
        }
        return tokens;
    }
}