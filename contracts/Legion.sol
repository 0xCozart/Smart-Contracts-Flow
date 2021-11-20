// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Legion is ERC721, Ownable {
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

    struct LegionnaireBaseStats {
        string species;
        uint8 level;
        uint8 experience;
        uint8 attack;
        uint8 defense;
        uint8 speed;
        uint8 health;
        uint8 luck;
    }

    struct Legionnaire {
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

    mapping(uint => Legionnaire) public legionnaires;

    string[10] public species = ["Orc", "Goblin", "Human", "Troll", "Dwarf", "Elf", "Ogre", "Lizard", "Gnome", "Dragon"];

    /**
     * @dev randomized species selection with a lower chance of generating a "Dragon" species
     * @param {address} _owner
     * @return string species
     */
    function _weightedSpeciesGenerator(address _address) private returns (string memory) {
        randNonce++;
        uint8 speciesIndex = uint8(uint(keccak256(abi.encodePacked(block.timestamp, _address, randNonce))) % 10);
        if (speciesIndex == 9) {
            if (randNonce % 2 == 0) {
                speciesIndex = uint8(uint(keccak256(abi.encodePacked(block.timestamp, _address, randNonce))) % 10);
            }
        }
        return species[speciesIndex];
    }

    /**
     * @dev generates base stats for a new Legionnaire
     * @param {address} "msg.sender"
     * @return object of type LegionareBaseStats
     */
    function _generateBaseStats(address _address) private returns (LegionnaireBaseStats memory) {
        LegionnaireBaseStats memory stats;
        randNonce++;
        stats.level = 1;
        stats.experience = 0;
        stats.species = _weightedSpeciesGenerator(_address);
        stats.attack = uint8(uint(keccak256(abi.encodePacked(block.timestamp, _address, randNonce))) % 10);
        stats.defense = uint8(uint(keccak256(abi.encodePacked(block.timestamp, _address, randNonce))) % 10);
        stats.speed = uint8(uint(keccak256(abi.encodePacked(block.timestamp, _address, randNonce))) % 10);
        stats.level = uint8(uint(keccak256(abi.encodePacked(block.timestamp, _address, randNonce))) % 10);
        stats.health = 25;
        return stats;
    }

    function _mintLegionare(address _address) private {
        Legionnaire memory legionnaire;
        LegionnaireBaseStats memory stats = _generateBaseStats(_address);
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

        uint8 id = uint8(_tokenIdCounter.current());
        legionnaires[id] = legionnaire;
        tokenOwner[id] = _address;
        ownerToTokenAmount[_address]++;

        emit Transfer(address(this), _address, id);
    }

    function getLegion(address _address) public view returns (Legionnaire[] memory) {
        uint tokenAmount = ownerToTokenAmount[_address];
        require(tokenAmount > 0);

        Legionnaire[] memory legion = new Legionnaire[](tokenAmount);

        uint i = 0;
        uint index = 0;

        for (i = 0; i < ownerToTokenAmount[_address]; i++) {
            if (tokenOwner[i] == _address) {
                legion[index] = legionnaires[i];
                index++;
            }
        }
        return legion;
    }

    /* -------------------------------------------------------------------------- */

    function safeMint(uint _amount) public payable {
        require(msg.value >= (_amount * 0.069 ether), "Please send at least 0.069 ether (does not include gas)");
        require(_tokenIdCounter.current() <= 1000);

        _safemint(_amount, msg.sender);
    }

    function _safemint(uint _amount, address _address) private {
        for (uint i = 0; i <= _amount; i++) {
            _tokenIdCounter.increment();
            _mintLegionare(_address);
        }
    }
}
