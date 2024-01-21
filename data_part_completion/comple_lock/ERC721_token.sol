```solidity
function approve(address _approved, uint256 _tokenId) external payable {
    require(msg.sender == eggToOwner[_tokenId]);
    eggApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
}
```