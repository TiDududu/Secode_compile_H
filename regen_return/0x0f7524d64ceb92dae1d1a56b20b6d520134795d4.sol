pragma solidity ^0.8.0;

contract ProofOfWeakHands {
    mapping(address => uint) public balanceOf;
    uint public buyPrice = 1; // 1 token for 1 finney
    uint public sellPrice = 1; // 1 finney for 1 token

    event Transfer(address indexed from, address indexed to, uint value);

    function buyTokens() public payable {
        uint amount = msg.value / buyPrice;
        balanceOf[msg.sender] += amount;
    }

    function sellTokens(uint amount) public {
        require(balanceOf[msg.sender] >= amount, "Not enough tokens to sell");
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount * sellPrice);
    }

    function withdraw() public {
        uint amount = balanceOf[msg.sender];
        require(amount > 0, "No dividends to withdraw");
        balanceOf[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function fund() public payable {
        buyTokens();
    }

    function sellMyTokensDaddy() public {
        sellTokens(balanceOf[msg.sender]);
    }

    function getMeOutOfHere() public {
        sellMyTokensDaddy();
        withdraw();
    }

    function transferTokens(address to, uint amount) internal {
        require(balanceOf[msg.sender] >= amount, "Not enough tokens to transfer");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }
}