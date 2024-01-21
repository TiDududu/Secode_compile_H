pragma solidity ^0.4.26;

contract DEJToken {
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    uint256 public totalSupply;
    address public owner;

    function migrate(address newAddress, uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        balanceOf[msg.sender] -= amount;
        balanceOf[newAddress] += amount;
    }

    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a + b >= a);
        return a + b;
    }

    function safeSubtract(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function safeMult(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a == 0 || (a * b) / a == b);
        return a * b;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balanceOf[_owner];
    }

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] = safeSubtract(balanceOf[msg.sender], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        require(balanceOf[_from] >= _value);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] = safeSubtract(balanceOf[_from], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        allowance[_from][msg.sender] = safeSubtract(allowance[_from][msg.sender], _value);
    }

    function approve(address _spender, uint256 _value) public {
        allowance[msg.sender][_spender] = _value;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowance[_owner][_spender];
    }

    function increaseSupply(uint256 _value) public {
        require(msg.sender == owner);
        totalSupply = safeAdd(totalSupply, _value);
        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], _value);
    }
}