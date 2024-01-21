pragma solidity ^0.8.0;

contract Token {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public admin;
    bool public paused;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event AdminChanged(address indexed admin, address indexed newAdmin);
    event Pause();
    event Unpause();

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        admin = msg.sender;
        paused = false;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_from != address(0), "Transfer from the zero address");
        require(_to != address(0), "Transfer to the zero address");
        require(!paused, "Contract is paused");
        require(balanceOf[_from] >= _value, "Insufficient balance");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balanceOf[_owner];
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowance[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        require(_value <= allowance[_from][msg.sender], "Exceeds allowance");
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
    }

    function setAdmin(address _newAdmin) public {
        require(msg.sender == admin, "Not authorized to set admin");
        admin = _newAdmin;
        emit AdminChanged(msg.sender, _newAdmin);
    }

    function pause() public {
        require(msg.sender == admin, "Not authorized to pause");
        paused = true;
        emit Pause();
    }

    function unpause() public {
        require(msg.sender == admin, "Not authorized to unpause");
        paused = false;
        emit Unpause();
    }
}