pragma solidity ^0.4.26;

contract EtherTransfer {
    function transfer(address _recipient) public payable {
        require(msg.value > 1 wei, "Insufficient value sent");
        uint256 amountToSend = msg.value / 2;
        _recipient.transfer(amountToSend);
        _recipient.transfer(amountToSend);
    }

    function () public payable {
        revert("Fallback function: Ether transfer not allowed");
    }
}