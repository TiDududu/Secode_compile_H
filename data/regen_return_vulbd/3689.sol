pragma solidity ^0.4.26;

contract Ethertote {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;
    uint256 public totalSupply;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function proxyPayments() public payable {
        owner.transfer(msg.value);
    }

    function onTransfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "Invalid transfer address");
        require(balances[_from] >= _value, "Insufficient balance");
        balances[_from] -= _value;
        balances[_to] += _value;
    }

    function onApprove(address _spender, uint256 _value) internal {
        allowed[msg.sender][_spender] = _value;
    }

    function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public {
        require(_token == address(this), "Invalid token address");
        require(_extraData.length > 0, "Invalid extra data");
        onApprove(_from, _value);
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public {
        onTransfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public {
        allowed[msg.sender][_spender] = _value;
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        require(_value <= allowed[_from][msg.sender], "Insufficient allowance");
        allowed[_from][msg.sender] -= _value;
        onTransfer(_from, _to, _value);
    }
}