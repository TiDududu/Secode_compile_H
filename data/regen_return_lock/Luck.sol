pragma solidity ^0.4.26;

contract LuckContract {
    address public owner;
    uint public luck;
    uint[] public luckHistory;

    constructor() public {
        owner = msg.sender;
    }

    function getLuck() public view returns (uint) {
        return luck;
    }

    function changeLuck(uint newLuck) external {
        require(msg.sender == owner, "Only the owner can change the luck value");
        luckHistory.push(luck);
        luck = newLuck;
    }
}