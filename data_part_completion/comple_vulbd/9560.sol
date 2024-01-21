```solidity
function updateAd(uint256 id) public payable {
	require(msg.value >= adPriceMultiple.mul(adPriceHour));
	require(id == dappId);  
	purchaseTimestamp = now;  
	purchaseSeconds = 3600;  
	dappId++;  
}
```