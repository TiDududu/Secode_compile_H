```solidity
pragma solidity ^0.8.0;

contract GlobalGoldCash {
    string public name = "Global Gold Cash";
    string public symbol = "GGC";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner's address cannot be 0x0");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    function destruct() public onlyOwner {
        selfdestruct(payable(owner));
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "Transfer to the zero address");
        require(balanceOf[_from] >= _value, "Not enough balance");
        require(balanceOf[_to] + _value > balanceOf[_to], "Overflow");
        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function approveAndCall(address _spender, uint256 _value, bytes memory _data) public {
        approve(_spender, _value);
        ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, address(this), _data);
    }

    function burn(uint256 _value) public {
        require(balanceOf[msg.sender] >= _value, "Not enough balance");
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Transfer(msg.sender, address(0), _value);
    }

    function burnFrom(address _from, uint256 _value) public {
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
        require(_value <= balanceOf[_from], "Not enough balance");
        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -= _value;
        totalSupply -= _value;
        emit Transfer(_from, address(0), _value);
    }

    interface ApproveAndCallFallBack {
        function receiveApproval(address _from, uint256 _value, address _token, bytes memory _data) external;
    }
}
```