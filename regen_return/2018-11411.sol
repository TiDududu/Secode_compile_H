pragma solidity ^0.8.0;

contract DimonCoin {
    string public name = "DimonCoin";
    string public symbol = "FUD";
    uint8 public decimals = 8;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyPayloadSize(uint size) {
        require(msg.data.length >= size + 4, "Invalid payload size");
        _;
    }

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function getEthBalance(address _address) public view returns (uint) {
        return _address.balance;
    }

    function distributeFUD(address[] memory receivers, uint256[] memory amounts) public onlyOwner {
        require(receivers.length == amounts.length, "Arrays length mismatch");

        for (uint256 i = 0; i < receivers.length; i++) {
            _transfer(owner, receivers[i], amounts[i]);
        }
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balanceOf[_owner];
    }

    function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) {
        _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) {
        require(_value <= allowance[_from][msg.sender], "Insufficient allowance");
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
    }
}