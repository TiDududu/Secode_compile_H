pragma solidity ^0.4.26;

contract BraggerContract {
    address public owner;
    uint public initialBlocks;
    uint public totalBraggedVolume;

    struct Bragger {
        address walletAddress;
        uint amountBragged;
        string quote;
        string username;
        string pictureUrl;
    }
    Bragger[] public braggers;

    constructor() public {
        owner = msg.sender;
        initialBlocks = block.number;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
    }

    function random2() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.number, block.difficulty)));
    }

    function random3() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.number, block.difficulty, braggers.length)));
    }

    function getTotalBraggedVolume() public view returns (uint) {
        return totalBraggedVolume;
    }

    function getCurrentBragKing() public view returns (address, uint, string, string, string) {
        require(braggers.length > 0, "No braggers yet");
        Bragger storage currentBragKing = braggers[braggers.length - 1];
        return (currentBragKing.walletAddress, currentBragKing.amountBragged, currentBragKing.quote, currentBragKing.username, currentBragKing.pictureUrl);
    }

    function arrayLength() public view returns (uint) {
        return braggers.length;
    }

    function getBraggerAtIndex(uint index) public view returns (address, uint, string, string) {
        require(index < braggers.length, "Index out of range");
        Bragger storage bragger = braggers[index];
        return (bragger.walletAddress, bragger.amountBragged, bragger.username, bragger.pictureUrl);
    }

    function getUserNameByWallet(address wallet) public view returns (string) {
        for (uint i = 0; i < braggers.length; i++) {
            if (braggers[i].walletAddress == wallet) {
                return braggers[i].username;
            }
        }
        revert("Username not found");
    }

    function getUserPictureByWallet(address wallet) public view returns (string) {
        for (uint i = 0; i < braggers.length; i++) {
            if (braggers[i].walletAddress == wallet) {
                return braggers[i].pictureUrl;
            }
        }
        revert("Picture URL not found");
    }
}