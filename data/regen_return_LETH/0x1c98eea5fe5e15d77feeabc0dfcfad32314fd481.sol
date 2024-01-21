pragma solidity ^0.4.26;

contract EthConnectPonzi {
    mapping (address => uint256) public balanceOf;
    mapping (address => uint256) public dividendsOf;
    mapping (address => mapping (address => uint256)) public allowance;
    uint256 public tokenPrice;
    address public owner;

    constructor() public {
        owner = msg.sender;
        tokenPrice = 1; // 1 Ether
    }

    function withdraw() public {
        uint256 dividends = dividendsOf[msg.sender];
        require(dividends > 0);
        dividendsOf[msg.sender] = 0;
        msg.sender.transfer(dividends);
    }

    function sellMyTokensDaddy(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        uint256 etherAmount = amount * sellPrice();
        balanceOf[msg.sender] -= amount;
        dividendsOf[msg.sender] += etherAmount / 10; // 10% dividends
        owner.transfer(etherAmount - (etherAmount / 10)); // 90% to owner
    }

    function getMeOutOfHere() public {
        uint256 amount = balanceOf[msg.sender];
        sellMyTokensDaddy(amount);
        withdraw();
    }

    function fund() public payable {
        uint256 amount = msg.value / buyPrice();
        balanceOf[msg.sender] += amount;
    }

    function buyPrice() public view returns (uint256) {
        return tokenPrice;
    }

    function sellPrice() public view returns (uint256) {
        return tokenPrice;
    }

    function transferTokens(address from, address to, uint256 amount) internal {
        require(balanceOf[from] >= amount);
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }

    function transfer(address to, uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        transferTokens(msg.sender, to, amount);
    }

    function approve(address spender, uint256 amount) public {
        allowance[msg.sender][spender] = amount;
    }

    function transferFrom(address from, address to, uint256 amount) public {
        require(allowance[from][msg.sender] >= amount);
        allowance[from][msg.sender] -= amount;
        transferTokens(from, to, amount);
    }
}