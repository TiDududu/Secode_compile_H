pragma solidity ^0.4.26;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
}

contract TokenDispersal {
    function disperseEther(address[] recipients, uint256[] amounts) public payable {
        require(recipients.length == amounts.length, "Invalid input length");
        for (uint i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            recipients[i].transfer(amounts[i]);
        }
    }
    
    function disperseToken(address tokenAddress, address[] recipients, uint256[] amounts) public {
        require(recipients.length == amounts.length, "Invalid input length");
        ERC20 token = ERC20(tokenAddress);
        for (uint i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            require(token.transferFrom(msg.sender, recipients[i], amounts[i]), "Token transfer failed");
        }
    }
    
    function disperseTokenSimple(address tokenAddress, address[] recipients, uint256[] amounts) public {
        require(recipients.length == amounts.length, "Invalid input length");
        ERC20 token = ERC20(tokenAddress);
        for (uint i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            require(token.transfer(recipients[i], amounts[i]), "Token transfer failed");
        }
    }
}
