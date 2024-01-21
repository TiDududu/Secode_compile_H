pragma solidity ^0.4.26;

contract Caller {
    address public targetContract;

    constructor(address _targetContract) public {
        targetContract = _targetContract;
    }

    function delegate_2x(address _target, bytes4 _sig, uint256 _param1, uint256 _param2) public {
        require(_target != address(0), "Invalid target address");
        
        bool success;
        bytes memory result;
        (success, result) = _target.call(abi.encodeWithSelector(_sig, _param1, _param2));
        require(success, "Delegate call failed");
    }

    function testcall() public {
        delegate_2x(targetContract, bytes4(keccak256("someFunction(uint256,uint256)")), 10, 20);
    }
}