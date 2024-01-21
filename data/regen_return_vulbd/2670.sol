pragma solidity ^0.4.26;

contract BiddingContract {
    address public owner;
    uint public highestBid;
    address public highestBidder;
    uint public secondHighestBid;
    uint public biddingEndBlock;
    mapping(address => uint) public balances;

    constructor() public {
        owner = msg.sender;
        biddingEndBlock = block.number + 10;
    }

    function bid() public payable {
        require(msg.value > highestBid, "Bid must be higher than the current highest bid");
        
        if (highestBid != 0) {
            balances[highestBidder] += highestBid;
            if (msg.value > secondHighestBid) {
                secondHighestBid = msg.value;
            }
        }
        
        highestBidder = msg.sender;
        highestBid = msg.value;
        biddingEndBlock = block.number + 10;
    }

    function withdraw() public {
        uint amount = balances[msg.sender];
        require(amount > 0, "Balance must be greater than 0");
        
        balances[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    function winnerWithdraw() public {
        require(biddingClosed(), "Bidding period has not ended");
        require(msg.sender == highestBidder, "Only the highest bidder can withdraw");
        
        uint value = highestBid;
        highestBid = 0;
        highestBidder.transfer(value);
    }

    function ownerWithdraw() public {
        require(biddingClosed(), "Bidding period has not ended");
        require(msg.sender == owner, "Only the owner can withdraw");
        
        uint remainingBalance = address(this).balance;
        owner.transfer(remainingBalance);
    }

    function getMyBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function biddingClosed() public view returns (bool) {
        return block.number > biddingEndBlock;
    }

    function () public payable {
        bid();
    }
}