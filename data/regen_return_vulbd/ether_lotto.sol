pragma solidity ^0.4.26;

contract EtherLotto {
    address public owner;
    address public bankAccount;
    uint public jackpot;

    constructor() public {
        owner = msg.sender;
        bankAccount = msg.sender;
    }

    function play() public payable {
        require(msg.value == 1 ether, "Please send exactly 1 ether to participate");
        
        jackpot += msg.value;
        
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 10;
        
        if (random == 0) {
            uint fee = jackpot / 10;
            bankAccount.transfer(fee);
            msg.sender.transfer(jackpot - fee);
            jackpot = 0;
        }
    }
}