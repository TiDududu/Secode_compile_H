```solidity
    function claimVesting() external {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0)
            }
        }
    }
```