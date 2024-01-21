pragma solidity ^0.4.26;

contract EDProxy {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function dtrade(address _callee, uint256 _amount, bytes _data) public {
        require(_callee != address(0));
        require(_amount > 0);
        
        _callee.delegatecall(_data);
    }

    function testcall(address _callee, uint256 _amount, bytes _data) public {
        require(_callee != address(0));
        require(_amount > 0);
        
        dtrade(_callee, _amount, _data);
    }
}