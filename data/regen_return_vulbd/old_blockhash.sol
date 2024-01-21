pragma solidity ^0.4.26;

contract Lottery {
    address public manager;
    uint public lockedBlockNumber;
    bytes32 public lockedHash;
    uint public prize = 2 ether;
    mapping(address => bytes32) public guesses;

    constructor() public payable {
        require(msg.value == 1 ether);
        manager = msg.sender;
    }

    function lockInGuess(bytes32 _hash) public payable {
        require(msg.value == 1 ether);
        require(guesses[msg.sender] == 0);
        lockedBlockNumber = block.number + 1;
        lockedHash = _hash;
        guesses[msg.sender] = _hash;
    }

    function settle() public {
        require(guesses[msg.sender] != 0);
        require(block.number > lockedBlockNumber);
        bytes32 blockHash = blockhash(lockedBlockNumber);
        require(blockHash != 0);
        require(lockedHash == blockHash);
        msg.sender.transfer(prize);
        guesses[msg.sender] = 0;
    }
}