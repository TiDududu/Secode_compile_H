pragma solidity ^0.4.26;

contract GameContract {
    address public owner;
    uint public totalSize;
    uint public singlePrice;
    uint public gameIndex;
    bool public isLocked;
    address[] public players;
    mapping(address => uint) public playerTickets;

    constructor(uint _totalSize, uint _singlePrice) public {
        owner = msg.sender;
        totalSize = _totalSize;
        singlePrice = _singlePrice;
        gameIndex = 1;
        isLocked = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function updateLock(bool _isLocked) public onlyOwner {
        isLocked = _isLocked;
        if (_isLocked) {
            startNewGame();
        }
    }

    function stopGame() public onlyOwner {
        require(isLocked, "Game must be locked to stop");
        uint remainingBalance = address(this).balance;
        for (uint i = 0; i < players.length; i++) {
            address player = players[i];
            uint prize = playerTickets[player] * singlePrice;
            player.transfer(prize);
        }
        owner.transfer(remainingBalance);
        gameIndex++;
        delete players;
        isLocked = false;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function changeConfig(uint _totalSize, uint _singlePrice) public onlyOwner {
        totalSize = _totalSize;
        singlePrice = _singlePrice;
    }

    function startNewGame() public onlyOwner {
        require(isLocked, "Game must be locked to start a new game");
        gameIndex++;
        delete players;
    }

    function getGameInfo() public view returns (uint, uint, address[], uint, bool) {
        return (gameIndex, totalSize, players, singlePrice, isLocked);
    }

    function gameResult() public onlyOwner {
        require(isLocked, "Game must be locked to determine the result");
        require(players.length > 0, "No players in the game");
        uint winnerIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players.length))) % players.length;
        address winner = players[winnerIndex];
        uint prize = address(this).balance;
        winner.transfer(prize);
    }
}