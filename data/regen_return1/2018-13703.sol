pragma solidity ^0.4.26;

contract CERB_Coin {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    uint256 public tokenPrice;
    bool public icoStatus;
    address public beneficiary;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    mapping (address => bool) public frozenAccount;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed from, uint256 value);
    event FrozenFunds(address target, bool frozen);
    event ICOStatusChanged(bool status);
    event TokenPriceSet(uint256 price);
    event EtherWithdrawn(address to, uint256 amount);
    event AllowTransferTokenSet(address member, bool allowed);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol,
        uint8 tokenDecimals,
        uint256 initialTokenPrice,
        address initialOwner
    ) public {
        totalSupply = initialSupply * 10 ** uint256(tokenDecimals);
        balanceOf[initialOwner] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = tokenDecimals;
        owner = initialOwner;
        tokenPrice = initialTokenPrice;
        icoStatus = false;
        beneficiary = initialOwner;
    }

    function receiveApproval(address from, uint256 tokens, address token, bytes data) public {
        require(token == address(this));
        require(data.length == 0);
        transferFrom(from, msg.sender, tokens);
    }

    function () public payable {
        require(icoStatus);
        uint256 amount = msg.value / tokenPrice;
        require(balanceOf[owner] >= amount);
        balanceOf[owner] -= amount;
        balanceOf[msg.sender] += amount;
        emit Transfer(owner, msg.sender, amount);
    }

    function transfer(address to, uint256 tokens) public {
        require(!frozenAccount[msg.sender]);
        require(balanceOf[msg.sender] >= tokens);
        balanceOf[msg.sender] -= tokens;
        balanceOf[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
    }

    function approve(address spender, uint256 tokens) public {
        allowance[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
    }

    function transferFrom(address from, address to, uint256 tokens) public {
        require(!frozenAccount[from]);
        require(balanceOf[from] >= tokens);
        require(allowance[from][msg.sender] >= tokens);
        balanceOf[from] -= tokens;
        balanceOf[to] += tokens;
        allowance[from][msg.sender] -= tokens;
        emit Transfer(from, to, tokens);
    }

    function burn(uint256 tokens) public {
        require(balanceOf[msg.sender] >= tokens);
        balanceOf[msg.sender] -= tokens;
        totalSupply -= tokens;
        emit Burn(msg.sender, tokens);
    }

    function mintToken(address target, uint256 tokens) public onlyOwner {
        balanceOf[target] += tokens;
        totalSupply += tokens;
        emit Transfer(address(0), target, tokens);
    }

    function freezeAccount(address target, bool freeze) public onlyOwner {
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }

    function setICOStatus(bool status) public onlyOwner {
        icoStatus = status;
        emit ICOStatusChanged(status);
    }

    function setTokenPrice(uint256 price) public onlyOwner {
        tokenPrice = price;
        emit TokenPriceSet(price);
    }

    function withdrawEther(uint256 amount) public onlyOwner {
        beneficiary.transfer(amount);
        emit EtherWithdrawn(beneficiary, amount);
    }

    function setAllowTransferToken(address member, bool allowed) public onlyOwner {
        frozenAccount[member] = !allowed;
        emit AllowTransferTokenSet(member, allowed);
    }
}
