```solidity
function initialize(address _controller, uint256 _cap) public {
    require(address(_controller) != address(0));
    require(_cap > 0);
    require(owner == address(0));
    owner = msg.sender;
    delegation = _controller;
    delegatedFwd(_controller, msg.data);
}
```