pragma solidity ^0.4.26;

contract TokenSystem {
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    mapping(address => uint) public dividendsOf;
    uint public reserve;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event Withdraw(address indexed from, uint value);
    event Buy(address indexed from, uint value);

    function transfer(address _to, uint _value) public {
        require(_to != address(0));
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint _value) public {
        require(_to != address(0));
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
    }

    function dividends(address _address) public view returns (uint) {
        return dividendsOf[_address];
    }

    function withdraw() public {
        uint _dividends = dividendsOf[msg.sender];
        require(_dividends > 0);
        dividendsOf[msg.sender] = 0;
        msg.sender.transfer(_dividends);
        emit Withdraw(msg.sender, _dividends);
    }

    function reserve() public view returns (uint) {
        return reserve;
    }

    function buy() public payable {
        require(msg.value > 0);
        uint tokens = msg.value; // 1 ether = 1 token
        balanceOf[msg.sender] += tokens;
        reserve += msg.value;
        emit Buy(msg.sender, msg.value);
    }
}
