pragma solidity ^0.4.26;

contract BonusContract {
    mapping(address => uint) public rewards;
    mapping(address => bool) public firstWithdrawalBonusClaimed;

    function withdrawReward() public {
        require(rewards[msg.sender] > 0, "No rewards to withdraw");
        uint amount = rewards[msg.sender];
        rewards[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    function getFirstWithdrawalBonus() public {
        require(!firstWithdrawalBonusClaimed[msg.sender], "Bonus already claimed");
        rewards[msg.sender] += 100; // Assuming the bonus amount is 100
        firstWithdrawalBonusClaimed[msg.sender] = true;
    }
}