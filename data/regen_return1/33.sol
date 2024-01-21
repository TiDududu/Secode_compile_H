pragma solidity ^0.4.26;

contract ERC20Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(uint256 => address) public marked;
    mapping(address => bool) public hasMarked;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mark(address indexed from, uint256 index, bytes data);

    constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
    }

    function mark(bytes data) internal {
        require(balanceOf[msg.sender] > 0, "Sender does not have any tokens to mark");
        uint256 index = uint256(keccak256(abi.encodePacked(msg.sender, data)));
        marked[index] = msg.sender;
        hasMarked[msg.sender] = true;
        emit Mark(msg.sender, index, data);
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balanceOf[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        if (hasMarked[msg.sender]) {
            hasMarked[msg.sender] = false;
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        } else {
            revert("Sender has not marked tokens");
        }
    }
}