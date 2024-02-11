// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

error SeedTooShort();

/// @title CoinflipV2 10 in a Row
/// @author Tianchan Dong
/// @notice Contract used as part of the course Solidity and Smart Contract development
contract CoinflipV2 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) initializer public {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        seed = "It is a good practice to rotate seeds often in gambling";
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    
    string public seed;


    /// @notice Checks user input against contract generated guesses
    /// @param Guesses a fixed array of 10 elements which holds the user's guesses.
    ///                The guesses are either 1 or 0 for heads or tails.
    /// @return true if user correctly guesses each flip correctly or false otherwise
    function userInput(uint8[10] calldata Guesses) external view returns(bool) {
        uint8[10] memory generatedGuesses = getFlips();
        for (uint i = 0; i < 10; i++) {
            // Compare the user's guess with the generated guess
            if (Guesses[i] != generatedGuesses[i]) {
                // If any guess doesn't match, return false immediately
                return false;
            }
        }
        // If all guesses match, return true
        return true;
    }
    

    /// @notice Allows the owner of the contract to change the seed to a new one
    /// @param NewSeed a string which represents the new seed
    function seedRotation(string memory NewSeed) public onlyOwner {
        bytes memory seedBytes = bytes(NewSeed);
        uint seedLength = seedBytes.length;

        // Check if the new seed is at least 10 characters long
        if (seedLength < 10) {
            revert SeedTooShort();
        }
        // Perform rotational logic
        for (uint i = 0; i < 5; i++) {
        // Store the last character
        bytes1 lastChar = seedBytes[seedLength - 1];

        // Shift each character to the right by one position
        for (uint j = seedLength - 1; j > 0; j--) {
            seedBytes[j] = seedBytes[j - 1];
        }

        // Set the first character to the last character from the previous iteration
        seedBytes[0] = lastChar;
        }

        // Update the seed variable with the rotated seed
        seed = string(seedBytes);

        seed = NewSeed;
    }

    // -------------------- helper functions -------------------- //

    /// @notice This function generates 10 random flips by hashing characters of the seed
    /// @return A fixed 10 element array of type uint8 with only 1 or 0 as its elements
    function getFlips() public view returns(uint8[10] memory) {
        bytes memory stringInBytes = bytes(seed);
        uint seedLength = stringInBytes.length;

        uint8[10] memory results;

        uint interval = seedLength / 10;
        for (uint i = 0; i < 10; i++) {
            uint randomNum = uint(keccak256(abi.encodePacked(stringInBytes[i * interval], block.timestamp)));
            results[i] = randomNum % 2 == 0 ? 1 : 0;
        }

        return results;
    }
}
