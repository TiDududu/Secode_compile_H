```solidity
    function brag() public payable {
        require(msg.value > 0);
        braggers.push(Bragger({
            braggerAddress: msg.sender,
            braggedAmount: msg.value,
            braggerQuote: initialQuote
        }));
        totalBraggedValue += msg.value;
        totalbrags += 1;
        if(totalbrags == 1){
            winningpot = msg.value;
        } else {
            winningpot += msg.value/10;
        }
    }
```