```solidity
function settle() public {
    require(block.number > guesses[msg.sender].block);
    bytes32 winning_hash = blockhash(guesses[msg.sender].block);
    require(winning_hash == guesses[msg.sender].guess);
    msg.sender.transfer(1 ether);
    guesses[msg.sender].block = 0;
    guesses[msg.sender].guess = 0x0;
}
```