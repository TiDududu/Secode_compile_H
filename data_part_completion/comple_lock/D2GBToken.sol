```solidity
function PayForFlag(string b64email) public payable returns (bool success) {
    require(msg.value > 0);
    emit GetFlag(b64email, "Your flag content");
    return true;
}
```