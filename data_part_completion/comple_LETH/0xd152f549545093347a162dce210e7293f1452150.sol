```solidity
function disperseEther(address[] recipients, uint256[] values) external payable {
        require(recipients.length == values.length);
        for (uint256 i = 0; i < recipients.length; i++) {
            recipients[i].transfer(values[i]);
        }
    }
```