pragma solidity ^0.4.26;

contract TokenSale {
    address public owner;
    address public owner2;
    uint public tokenPrice;
    bool public active;

    mapping(address => uint) public balances;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor(address _owner2, uint _tokenPrice) public {
        owner = msg.sender;
        owner2 = _owner2;
        tokenPrice = _tokenPrice;
        active = true;
    }

    function tokens_buy() public payable {
        require(active, "Contract is not active");
        require(msg.value > 0, "Sent Ether must be greater than 0");

        uint tokenAmount = msg.value / tokenPrice;
        require(tokenAmount > 0, "Token amount must be greater than 0");

        balances[msg.sender] += tokenAmount;
        uint owner2Share = msg.value / 10;
        owner2.transfer(owner2Share);
    }

    function withdraw(uint amount) public onlyOwner {
        if (amount == 0) {
            msg.sender.transfer(address(this).balance);
        } else {
            require(address(this).balance >= amount, "Insufficient balance");
            msg.sender.transfer(amount);
        }
    }

    function change_token_price(uint newPrice) public onlyOwner {
        tokenPrice = newPrice;
    }

    function change_active(bool _active) public onlyOwner {
        active = _active;
    }
}