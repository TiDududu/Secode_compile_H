```solidity
	function addSupportedToken(
		address _address, 
		uint256 _price, 
		uint256 _startTime, 
		uint256 _endTime
	) public onlyOwner returns (bool)  {
		require(_address != 0x0);
		supportedERC20Token.push(_address);
		prices[_address] = _price;
		starttime[_address] = _startTime;
		endtime[_address] = _endTime;
		emit AddSupportedToken(_address, _price, _startTime, _endTime);
		return true;
	}
```