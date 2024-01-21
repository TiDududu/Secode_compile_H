pragma solidity ^0.4.26;

contract Proxy {
    address public owner;
    address public controller;
    
    modifier onlyOwner {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }
    
    constructor(address _controller, address _owner) public {
        controller = _controller;
        owner = _owner;
    }
    
    function delegatedFwd() public returns (bool success) {
        (success, ) = controller.delegatecall(msg.data);
        require(success, "Delegated call failed");
    }
    
    function transferDelegation(address newController) public onlyOwner {
        require(newController != address(0), "Invalid address");
        controller = newController;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
    
    function initialize(address _controller, address _owner) public {
        require(controller == address(0) && owner == address(0), "Already initialized");
        controller = _controller;
        owner = _owner;
    }
}