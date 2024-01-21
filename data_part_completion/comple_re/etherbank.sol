```solidity
function withdrawBalance() {
		uint balance = userBalances[msg.sender];
		userBalances[msg.sender] = 0;
		msg.sender.transfer(balance);
	}
```