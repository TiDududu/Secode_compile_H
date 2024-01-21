pragma solidity ^0.4.26;

interface ERC20 {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function balanceOf(address _owner) external view returns (uint256 balance);
}

contract SponsoredItemGooRaffle {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    struct Raffle {
        uint endTime;
        uint ticketPrice;
        address tokenAddress;
        address winner;
        mapping(address => uint) ticketsBought;
        address[] participants;
    }

    Raffle public currentRaffle;

    function startTokenRaffle(uint _endTime, uint _ticketPrice, address _tokenAddress) public {
        require(msg.sender == owner, "Only owner can start a raffle");
        currentRaffle = Raffle(_endTime, _ticketPrice, _tokenAddress, address(0), new address[](0));
    }

    function buyRaffleTicket(uint _numTickets) public {
        require(currentRaffle.endTime > now, "Raffle has ended");
        require(_numTickets > 0, "Number of tickets should be greater than 0");

        ERC20 token = ERC20(currentRaffle.tokenAddress);
        require(token.balanceOf(msg.sender) >= _numTickets * currentRaffle.ticketPrice, "Insufficient balance");

        uint totalCost = _numTickets * currentRaffle.ticketPrice;
        require(token.transferFrom(msg.sender, address(this), totalCost), "Token transfer failed");

        for (uint i = 0; i < _numTickets; i++) {
            currentRaffle.ticketsBought[msg.sender]++;
            currentRaffle.participants.push(msg.sender);
        }
    }

    function awardRafflePrize() public {
        require(msg.sender == owner, "Only owner can award prize");
        require(currentRaffle.endTime <= now, "Raffle has not ended yet");
        require(currentRaffle.participants.length > 0, "No participants in the raffle");

        uint index = uint(keccak256(abi.encodePacked(blockhash(block.number - 1)))) % currentRaffle.participants.length;
        currentRaffle.winner = currentRaffle.participants[index];
    }
}
