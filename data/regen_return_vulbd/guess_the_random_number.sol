pragma solidity ^0.4.26;

contract GuessTheRandomNumberChallenge {
    bytes32 private answer;

    constructor() public {
        answer = keccak256(abi.encodePacked(blockhash(block.number - 1), now));
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint256 guessedNumber) public {
        require(guessedNumber == uint256(answer), "Incorrect guess");
        msg.sender.transfer(2 ether);
    }
}