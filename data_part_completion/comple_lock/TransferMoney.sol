```solidity
function depositMoney(string message) payable public {
    bankAccountMoney[msg.sender] += msg.value;
}
```