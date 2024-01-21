pragma solidity ^0.4.26;

contract PyramidScheme {
    mapping(address => uint) public balanceOf;
    mapping(address => uint) public dividendOf;
    mapping(address => uint) public lastPayout;

    function buyTokens() public payable {
        require(msg.value > 0);
        uint tokensBought = msg.value;
        balanceOf[msg.sender] += tokensBought;
        uint dividends = (tokensBought * 10) / 100; // 10% dividends
        dividendOf[msg.sender] += dividends;
        lastPayout[msg.sender] = now;
    }

    function balanceOf(address user) public view returns (uint) {
        return balanceOf[user];
    }

    function withdraw() public {
        uint dividends = dividendOf[msg.sender];
        require(dividends > 0);
        uint amount = dividends;
        dividendOf[msg.sender] = 0;
        lastPayout[msg.sender] = now;
        msg.sender.transfer(amount);
    }

    function reinvestDividends() public {
        uint dividends = dividendOf[msg.sender];
        require(dividends > 0);
        uint tokensBought = dividends;
        balanceOf[msg.sender] += tokensBought;
        dividendOf[msg.sender] = 0;
        lastPayout[msg.sender] = now;
    }
}