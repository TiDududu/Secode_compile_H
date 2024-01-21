```solidity
function makeBet() public payable {
    bool won = (block.number % 2) == 0;

    bets.push(Bet(msg.value, block.number, won));

    if(won) {
        if(!msg.sender.send(msg.value)) {
            throw;
        }
    }
}
```