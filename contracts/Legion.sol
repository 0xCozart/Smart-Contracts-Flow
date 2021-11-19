// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract MyCollectible is ERC721, Ownable {
/* ---------------------------- contract getters ---------------------------- */
    using Counters for Counters.Counter;
    mapping(address => uint) public ownerToTokenAmount;
    mapping(uint => address) public tokenOwner;
    Counters.Counter private _tokenIdCounter;

  constructor() ERC721("Legion", "LGN") {}

/* ---------------------------------- utils --------------------------------- */
    uint randNonce = 0;

/* -------------------------------------------------------------------------- */
/*                         Legion/Legionare properties                        */
/* -------------------------------------------------------------------------- */
    
    struct LeggionaireBaseStats {
        string species;
        uint8 level;
        uint8 experience;
        uint8 attack;
        uint8 defense;
        uint8 speed;
        uint8 health;
        uint8 luck;
    }

    struct Leggionnaire {
        string name;
        uint8 level; 
        string species;
        uint8 age;
        uint8 powerLevel;
        uint8 health;
        uint8 attack;
        uint8 defense;
        uint8 speed;
        uint8 luck;
        uint8 experience;
    }

    struct Legion {
        Legionnaire[] members;
    }

    mapping (address => uint) public legions;
    mapping (uint => Legionnaire) public legionaires;

    string[10] public species = [
        "Orc",
        "Goblin",
        "Human",
        "Troll",
        "Dwarf",
        "Elf",
        "Ogre",
        "Lizard",
        "Gnome",
        "Dragon"];

    /** 
      * @dev randomized species selection with a lower chance of generating a "Dragon" species
      * @param {address} _owner 
      * @return string species
      */
    function _weightedSpeciesGenerator(address _address) private view returns (string memory) {
        randNonce++;
        uint8 speciesIndex = uint(keccak256(abi.encodePacked(now, _address, randNonce))) % 10;
        if (speciesIndex == 9) {
            if (randNonce % 2 == 0) {
                speciesIndex = uint(keccak256(abi.encodePacked(now, _address, randNonce))) % 10;
            }
        }
        return species[speciesIndex];
    }


    /** 
      * @dev generates base stats for a new Legionnaire
      * @param {address} "msg.sender" 
      * @return object of type LegionareBaseStats
      */
    function _generateBaseStats(address _address) private view returns (LegionareBaseStats) {
        LegionareBaseStats stats;
        randNonce++;
        stats.level = 1;
        stats.experience = 0;
        stats.species = _weightedSpeciesGenerator(_address);
        stats.attack = uint(keccak256(abi.encodePacked(now, _address, randNonce))) % 10;
        stats.defense = uint(keccak256(abi.encodePacked(now, _address, randNonce))) % 10; 
        stats.speed = uint(keccak256(abi.encodePacked(now, _address, randNonce))) % 10;
        stats.level = uint(keccak256(abi.encodePacked(now, _address, randNonce))) % 10;
        stats.health = 25;
        return stats;
    }

    function _mintLegionare(address _address) private {
      Legionnaire legionnaire;
      LegionBaseStats stats = _generateBaseStats(_address);
      legionnaire.name = "testLegionare";
      legionnaire.level = stats.level;
      legionnaire.species = stats.species;
      legionnaire.age = 1;
      legionnaire.powerLevel = 1;
      legionnaire.health = stats.health;
      legionnaire.attack = stats.attack;
      legionnaire.defense = stats.defense;
      legionnaire.speed = stats.speed;
      legionnaire.luck = stats.luck;
      legionnaire.experience = stats.experience;

      uint8 id = _tokenIdCounter.current();
      legionaires[id] = legionnaire;
      legions[_address].members.push(id);
      tokenOwner[id] = _address;
      ownerToTokenAmount[_address]++;
      
      emit Transfer(address(this), _address, id);
    }


/* -------------------------------------------------------------------------- */
  

    function safeMint(uint _amount) public {
        require(msg.value >= (_amount * 0.069 ether), "Please send at least 0.069 ether (does not include gas)");
        require(_tokenIdCounter.current() <= 1000);

        _safemint(msg.value, _tokenIdCounter);
        _tokenIdCounter.increment();
    }

    function _safemint(uint amount, address _address) private {
      for (uint i = 0; i <= _amount; i++) {
        _tokenIdCounter.increment();
        _mintLegionare(_address);
      }
    }
}