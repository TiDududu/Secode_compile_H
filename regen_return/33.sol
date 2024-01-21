```solidity
pragma solidity ^0.8.0;

contract CustomToken {
    string public symbol;
    mapping(address => uint) public balances;
    uint public totalSupply;

    constructor() {
        symbol = "a2g";
        totalSupply = 100000; // Total supply of custom token
        balances[msg.sender] = totalSupply; // Assign all tokens to the contract deployer
    }

    // Allows the user to mark their message on the blockchain
    function mark(string memory message) public {
        // Mark the message on the blockchain
        // ...
    }

    // Returns the total supply of the custom token
    function getTotalSupply() public view returns (uint) {
        return totalSupply;
    }

    // Returns the balance of a specific address
    function getBalance(address account) public view returns (uint) {
        return balances[account];
    }

    // Allows the user to transfer tokens to another address
    function transfer(address to, uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance"); // Check if the sender has enough tokens
        balances[msg.sender] -= amount; // Deduct the tokens from the sender
        balances[to] += amount; // Add the tokens to the recipient
    }
}
```