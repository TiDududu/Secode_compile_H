pragma solidity ^0.4.26;

contract SimpleLottery {
    address public organizer;
    mapping(address => uint) public bets;

    constructor() public {
        organizer = msg.sender;
    }

    function() public {
        revert();
    }

    function makeBet() public payable {
        require(msg.value > 0, "Value sent must be greater than 0");
        bets[msg.sender] = block.number % 2;
    }

    function getBets() public view returns (address[], uint[]) {
        require(msg.sender == organizer, "Only the organizer can access this function");
        
        address[] memory addresses = new address[](addressCount);
        uint[] memory betValues = new uint[](addressCount);
        
        uint addressCount = 0;
        for (uint i = 0; i < addressCount; i++) {
            if (bets[addresses[i]] > 0) {
                betValues[i] = bets[addresses[i]];
            }
        }
        
        return (addresses, betValues);
    }

    function destroy() public {
        require(msg.sender == organizer, "Only the organizer can destroy the contract");
        selfdestruct(organizer);
    }
}