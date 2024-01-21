pragma solidity ^0.4.26;

contract TokenSystem {
    mapping (address => uint256) public balanceOf;
    uint256 public sellPrice;
    uint256 public buyPrice;
    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Sell(address indexed from, uint256 value);
    event Fund(address indexed from, uint256 value);
    event Withdraw(address indexed from, uint256 value);

    constructor() public {
        owner = msg.sender;
        sellPrice = 1; // 1 wei
        buyPrice = 1; // 1 wei
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balanceOf[_owner];
    }

    function withdraw() public {
        uint256 amount = balanceOf[msg.sender];
        balanceOf[msg.sender] = 0;
        msg.sender.transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function sellMyTokensDaddy(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        balanceOf[owner] += amount;
        balanceOf[msg.sender] -= amount;
        emit Sell(msg.sender, amount);
    }

    function getMeOutOfHere() public {
        uint256 amount = balanceOf[msg.sender];
        uint256 ethAmount = amount * sellPrice;
        balanceOf[msg.sender] = 0;
        balanceOf[owner] += amount;
        msg.sender.transfer(ethAmount);
        emit Sell(msg.sender, amount);
        emit Withdraw(msg.sender, ethAmount);
    }

    function fund() public payable {
        uint256 amount = msg.value / buyPrice;
        balanceOf[msg.sender] += amount;
        emit Fund(msg.sender, amount);
    }

    function buyPrice() public view returns (uint256 price) {
        return buyPrice;
    }

    function sellPrice() public view returns (uint256 price) {
        return sellPrice;
    }

    function transferTokens(address _from, address _to, uint256 _value) internal {
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) public {
        transferTokens(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        transferTokens(_from, _to, _value);
    }
}