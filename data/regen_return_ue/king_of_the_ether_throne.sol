pragma solidity ^0.4.26;

contract KingOfTheEtherThrone {
    address public wizardAddress;
    uint public claimPrice;
    uint public numberOfMonarchs;
    
    struct Monarch {
        address monarchAddress;
        string name;
        uint claimPrice;
    }
    
    Monarch public currentMonarch;
    Monarch[] public pastMonarchs;
    
    event ThroneClaimed(address usurper, string name, uint newClaimPrice);
    
    constructor() public {
        wizardAddress = msg.sender;
        currentMonarch.monarchAddress = msg.sender;
        currentMonarch.name = "Wizard";
        claimPrice = 1 ether;
    }
    
    function numberOfMonarchs() public view returns (uint) {
        return pastMonarchs.length;
    }
    
    function claimThrone(string memory name) public payable {
        require(msg.value >= claimPrice, "Insufficient claim fee");
        
        if (msg.value > claimPrice) {
            msg.sender.transfer(msg.value - claimPrice);
        }
        
        wizardAddress.transfer(claimPrice);
        
        pastMonarchs.push(currentMonarch);
        emit ThroneClaimed(currentMonarch.monarchAddress, currentMonarch.name, msg.value);
        
        currentMonarch.monarchAddress = msg.sender;
        currentMonarch.name = name;
        currentMonarch.claimPrice = msg.value * 2;
        claimPrice = currentMonarch.claimPrice;
        numberOfMonarchs++;
    }
    
    function () external payable {
        claimThrone("Anonymous");
    }
}