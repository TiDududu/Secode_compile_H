```solidity
function refundAll() external {
    require(msg.sender == bankOwner);
    for (uint i = 0; i < user.length; i++) {
        address payable userAddress = address(uint160(user[i]));
        uint256 amount = ledger[user[i]];
        userAddress.transfer(amount);
        ledger[user[i]] = 0;
    }
}
```