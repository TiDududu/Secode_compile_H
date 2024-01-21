pragma solidity ^0.4.26;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
}

contract AccessControl {
    address public admin;
    address public service;
    address public finance;
    bool public paused;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyAdminOrService() {
        require(msg.sender == admin || msg.sender == service, "Only admin or service can call this function");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    function setAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "Invalid address");
        admin = newAdmin;
    }

    function doPause() public onlyAdmin {
        paused = true;
    }

    function doUnpause() public onlyAdmin {
        paused = false;
    }

    function setService(address newService) public {
        require(msg.sender == admin || msg.sender == service, "Unauthorized");
        require(newService != address(0), "Invalid address");
        service = newService;
    }

    function setFinance(address newFinance) public {
        require(msg.sender == admin || msg.sender == finance, "Unauthorized");
        require(newFinance != address(0), "Invalid address");
        finance = newFinance;
    }

    function withdraw(address token, address to, uint256 amount) public {
        require(msg.sender == finance || msg.sender == admin, "Unauthorized");
        if (token == address(0)) {
            require(address(this).balance >= amount, "Insufficient balance");
            if (to == address(0)) {
                to = finance;
            }
            to.transfer(amount);
        } else {
            ERC20 erc20 = ERC20(token);
            require(erc20.balanceOf(address(this)) >= amount, "Insufficient balance");
            require(erc20.transfer(to, amount), "Transfer failed");
        }
    }
}