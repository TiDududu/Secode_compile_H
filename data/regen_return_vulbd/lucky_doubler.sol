pragma solidity ^0.4.26;

contract LuckyDoubler {
    address public owner;
    uint public multiplier = 2;
    uint public feePercentage = 10;
    address[] public players;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function init() public payable {
        require(msg.value == 1 ether, "Deposit 1 ether to participate");
        players.push(msg.sender);
    }

    function join() public payable {
        require(msg.value == 1 ether, "Deposit 1 ether to participate");
        players.push(msg.sender);
    }

    function rand(uint _max) private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, players.length))) % _max;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function changeMultiplier(uint _newMultiplier) public onlyOwner {
        multiplier = _newMultiplier;
    }

    function changeFee(uint _newFeePercentage) public onlyOwner {
        require(_newFeePercentage <= 100, "Fee percentage cannot exceed 100");
        feePercentage = _newFeePercentage;
    }
}