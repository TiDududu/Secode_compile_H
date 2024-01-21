```solidity
function sendPositiveWhuffies(address _to, string message) public payable {
        require(msg.value > 0);
        stats[_to].positiveWhuffies += msg.value;            
        PositiveWhuffiesSent(msg.sender, _to, msg.value, message);
    }
```