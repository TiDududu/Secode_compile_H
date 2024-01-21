pragma solidity ^0.4.26;

contract DelegateCallSelfDestruct {
    function delegatecall_selfdestruct(address _target) public {
        require(_target != address(0));
        
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, _target, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)
            
            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                selfdestruct(msg.sender)
            }
        }
    }
}