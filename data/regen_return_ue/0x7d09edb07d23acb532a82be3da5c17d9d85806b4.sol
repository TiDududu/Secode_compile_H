pragma solidity ^0.4.26;

contract SimpleGame {
    address public owner;
    address public designatedAddress;
    bool public isOpen;

    mapping(address => uint) public playerWagers;
    address[] public players;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    modifier isOpenToPublic() {
        require(isOpen, "Game is not open to the public");
        _;
    }

    modifier onlyRealPeople() {
        require(msg.sender == tx.origin, "Contracts are not allowed to play");
        _;
    }

    modifier onlyPlayers() {
        require(playerWagers[msg.sender] > 0, "Player has no active wager");
        _;
    }

    constructor() public {
        owner = msg.sender;
        isOpen = true;
    }

    function openGame() public onlyOwner {
        isOpen = true;
    }

    function closeGame() public onlyOwner {
        isOpen = false;
    }

    function setDesignatedAddress(address _address) public onlyOwner {
        designatedAddress = _address;
    }

    function wager() public payable isOpenToPublic onlyRealPeople {
        require(msg.value > 0, "Wager amount must be greater than 0");
        playerWagers[msg.sender] += msg.value;
        players.push(msg.sender);
    }

    function play() public isOpenToPublic onlyOwner {
        // Random number generation algorithm to determine winners and losers
        address winner = players[0]; // Placeholder for winner determination
        uint totalWager = 0;
        for (uint i = 0; i < players.length; i++) {
            totalWager += playerWagers[players[i]];
        }
        uint prize = totalWager * 90 / 100;
        winner.transfer(prize);
    }

    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        designatedAddress.transfer(msg.value);
    }

    function payout(address _winner) public onlyOwner {
        uint totalWager = 0;
        for (uint i = 0; i < players.length; i++) {
            totalWager += playerWagers[players[i]];
        }
        uint prize = totalWager * 90 / 100;
        _winner.transfer(prize);
    }

    function donateToWhale(address _address) public onlyOwner {
        uint balance = address(this).balance;
        _address.transfer(balance);
    }
}