pragma solidity ^0.4.26;

contract EtherGet {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function withdrawTokens(address _tokenContract, uint256 _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw tokens");
        require(_tokenContract != address(0), "Invalid token contract address");
        
        // Perform token transfer logic here
    }

    function withdrawEther(uint256 _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw ether");
        require(address(this).balance >= _amount, "Insufficient contract balance");
        
        owner.transfer(_amount);
    }

    function getTokens(address _targetAddress, uint256 _numCalls) public {
        require(msg.sender == owner, "Only the owner can get tokens");
        require(_targetAddress != address(0), "Invalid target address");
        
        for (uint256 i = 0; i < _numCalls; i++) {
            _targetAddress.call.value(0)(bytes4(keccak256("transfer(address,uint256)")), owner, 100);
        }
    }
}