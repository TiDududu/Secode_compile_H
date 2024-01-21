pragma solidity ^0.4.26;

contract Governmental {
    address public owner;
    address public lastInvestor;
    uint public jackpot;
    uint public lastInvestmentTime;

    constructor() public {
        owner = msg.sender;
    }

    function invest() public payable {
        require(msg.value >= jackpot / 2, "Investment should be at least half of the current jackpot");
        lastInvestor = msg.sender;
        jackpot += msg.value / 2;
        lastInvestmentTime = now;
    }

    function resetInvestment() public {
        require(msg.sender == lastInvestor || (msg.sender == owner && now >= lastInvestmentTime + 1 days), "Only last investor or owner after a certain time can reset investment");
        uint amountToTransfer = jackpot;
        jackpot = 0;
        if (msg.sender == lastInvestor) {
            lastInvestor.transfer(amountToTransfer);
        } else {
            owner.transfer(address(this).balance);
        }
    }
}

contract Attacker {
    Governmental public target;

    constructor(address _target) public {
        target = Governmental(_target);
    }

    function attack() public {
        target.resetInvestment();
    }
}