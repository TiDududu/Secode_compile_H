pragma solidity ^0.4.26;

contract Lottery {
    uint public constant BLOCKS_PER_ROUND = 100;
    uint public constant TICKET_PRICE = 1;
    uint public constant BLOCK_REWARD = 2;

    struct Round {
        uint decisionBlockNumber;
        uint[] subpots;
        mapping(uint => bool) isCashed;
    }

    mapping(uint => Round) public rounds;

    function getBlocksPerRound() public view returns (uint) {
        return BLOCKS_PER_ROUND;
    }

    function getTicketPrice() public view returns (uint) {
        return TICKET_PRICE;
    }

    function getRoundIndex() public view returns (uint) {
        return block.number / BLOCKS_PER_ROUND;
    }

    function getIsCashed(uint roundIndex, uint subpotIndex) public view returns (bool) {
        return rounds[roundIndex].isCashed[subpotIndex];
    }

    function calculateWinner(uint roundIndex, uint subpotIndex, uint decisionBlockNumber, bytes32 blockHash) public view returns (address) {
        return address(uint(keccak256(abi.encodePacked(decisionBlockNumber, blockHash, roundIndex, subpotIndex))) % 2**160);
    }

    function getDecisionBlockNumber(uint roundIndex, uint subpotIndex) public view returns (uint) {
        return rounds[roundIndex].decisionBlockNumber;
    }

    function getSubpotsCount(uint roundIndex) public view returns (uint) {
        return rounds[roundIndex].subpots.length;
    }

    function getSubpot(uint roundIndex, uint subpotIndex) public view returns (uint) {
        return rounds[roundIndex].subpots[subpotIndex];
    }

    function cash(uint roundIndex, uint subpotIndex, address winner) public {
        require(!rounds[roundIndex].isCashed[subpotIndex], "Subpot already cashed out");
        rounds[roundIndex].isCashed[subpotIndex] = true;
        winner.transfer(rounds[roundIndex].subpots[subpotIndex]);
    }
}