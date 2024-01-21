```solidity
function GuessTheRandomNumberChallenge() public payable {
    answer = uint8(keccak256(block.blockhash(block.number-1), now));
}
```