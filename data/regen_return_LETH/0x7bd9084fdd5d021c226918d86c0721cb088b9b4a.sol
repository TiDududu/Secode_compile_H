pragma solidity ^0.4.26;

interface ERC20Basic {
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
}

contract MultiSend {
    function multiSend(address token, address[] memory recipients, uint256[] memory amounts) public {
        require(recipients.length == amounts.length, "Invalid input");
        ERC20Basic erc20 = ERC20Basic(token);
        for (uint i = 0; i < recipients.length; i++) {
            erc20.transfer(recipients[i], amounts[i]);
        }
    }
    
    function multiSendEth(address[] memory recipients, uint256[] memory amounts) public payable {
        require(recipients.length == amounts.length, "Invalid input");
        uint256 totalAmount = 0;
        for (uint i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }
        require(msg.value >= totalAmount, "Insufficient Ether sent");
        for (uint j = 0; j < recipients.length; j++) {
            recipients[j].transfer(amounts[j]);
        }
        if (msg.value > totalAmount) {
            msg.sender.transfer(msg.value - totalAmount);
        }
    }
}