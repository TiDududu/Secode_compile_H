```solidity
function lockforTransfer() payable public returns(uint) {
    transNonce++;
    Details memory newTransfer = Details(msg.value, msg.sender, transNonce);
    transferDetails[transNonce] = newTransfer;
    transferList[msg.sender].push(transNonce);
    emit Locked(msg.sender, msg.value);
    return transNonce;
}
```