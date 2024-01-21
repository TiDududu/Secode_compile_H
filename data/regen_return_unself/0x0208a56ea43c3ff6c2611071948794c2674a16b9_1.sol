pragma solidity ^0.4.26;

contract SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract ErbiumCoin is SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply) public {
        name = "ErbiumCoin";
        symbol = "ERB";
        decimals = 18;
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0));
        require(value <= balanceOf[msg.sender]);

        balanceOf[msg.sender] = sub(balanceOf[msg.sender], value);
        balanceOf[to] = add(balanceOf[to], value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0));
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);

        balanceOf[from] = sub(balanceOf[from], value);
        balanceOf[to] = add(balanceOf[to], value);
        allowance[from][msg.sender] = sub(allowance[from][msg.sender], value);
        emit Transfer(from, to, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        allowance[msg.sender][spender] = add(allowance[msg.sender][spender], addedValue);
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        uint256 oldValue = allowance[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            allowance[msg.sender][spender] = 0;
        } else {
            allowance[msg.sender][spender] = sub(oldValue, subtractedValue);
        }
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    function mineToken(uint256 value) public {
        totalSupply = add(totalSupply, value);
        balanceOf[msg.sender] = add(balanceOf[msg.sender], value);
        emit Transfer(address(0), msg.sender, value);
    }

    function () public payable {
        revert();
    }
}