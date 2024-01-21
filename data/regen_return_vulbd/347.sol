pragma solidity ^0.4.26;

contract Crowdsale {
    address public owner;
    address public minter;
    uint public rate;
    uint public startTime;
    uint public endTime;
    mapping(address => uint) public balances;

    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
    event TokensTransfer(address indexed sender, address indexed receiver, uint amount, bool success);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyWhileOpen() {
        require(now >= startTime && now <= endTime, "Crowdsale is not open");
        _;
    }

    constructor(uint _rate, uint _startTime, uint _endTime) public {
        owner = msg.sender;
        rate = _rate;
        startTime = _startTime;
        endTime = _endTime;
    }

    function setMinter(address _minter) public onlyOwner {
        minter = _minter;
    }

    function buyTokens(address _beneficiary) public payable onlyWhileOpen {
        require(msg.value > 0, "Value should be greater than 0");
        uint tokens = msg.value * rate;
        balances[_beneficiary] += tokens;
        emit TokenPurchase(msg.sender, _beneficiary, msg.value, tokens);
    }

    function transferTokens(address _to, uint _amount) public onlyWhileOpen {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        emit TokensTransfer(msg.sender, _to, _amount, true);
    }
}