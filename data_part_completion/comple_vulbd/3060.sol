```solidity
function release(address _addr) external {
        require(owners[msg.sender]);
        require(_addr != address(0));
        require(now >= releaseBlocks[_addr]);
        uint256 amount = lockAmounts[_addr];
        delete lockAmounts[_addr];
        delete releaseBlocks[_addr];
        token.transfer(_addr, amount);
    }
```