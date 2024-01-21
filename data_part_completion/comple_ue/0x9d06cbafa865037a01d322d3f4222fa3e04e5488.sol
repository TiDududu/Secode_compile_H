```solidity
    function tokens_buy() payable returns (bool)  {
        require(msg.value > 0);
        uint tokens = msg.value / token_price;
        require(tokens > 0);
        require(active == 1);
        // process token transfer to the buyer
        return true;
    }
```