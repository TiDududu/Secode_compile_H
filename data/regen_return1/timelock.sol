pragma solidity ^0.4.26;

contract TimeLockedWallet {
    struct Deposit {
        uint256 amount;
        uint256 releaseTime;
    }
    
    mapping(address => Deposit) public deposits;

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        deposits[msg.sender] = Deposit(msg.value, now + 1 weeks);
    }

    function increaseLockTime(uint256 _additionalSeconds) public {
        require(deposits[msg.sender].amount > 0, "No deposit found for the sender");
        deposits[msg.sender].releaseTime += _additionalSeconds;
    }

    function withdraw() public {
        require(deposits[msg.sender].amount > 0, "No deposit found for the sender");
        require(now >= deposits[msg.sender].releaseTime, "Funds are still locked");
        
        uint256 amount = deposits[msg.sender].amount;
        deposits[msg.sender].amount = 0;
        deposits[msg.sender].releaseTime = 0;
        msg.sender.transfer(amount);
    }
}
