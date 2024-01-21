```solidity
function loseWager(uint256 amount) 
internal 
{
    whale.call.value(amount)(bytes4(keccak256("donate()")));
    totalDonated += amount;
    emit Lose(amount, whale);
}
```