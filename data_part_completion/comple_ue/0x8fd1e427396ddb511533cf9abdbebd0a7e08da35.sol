```solidity
function WithdrawToken(address token, uint256 amount, address to)
public 
onlyOwner
{
    // You need to complete this function
    require(Token(token).transfer(to, amount));
}
```