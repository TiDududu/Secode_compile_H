pragma solidity ^0.4.26;

contract ClassicCheck {
    function isClassic(address _address) public view returns (bool) {
        // logic to check if the address is classic
    }
}

contract SafeConditionalHFTransfer {
    ClassicCheck classicCheckContract;
    
    constructor(address _classicCheckAddress) public {
        classicCheckContract = ClassicCheck(_classicCheckAddress);
    }
    
    function classicTransfer(address _to, uint _amount) public {
        if (classicCheckContract.isClassic(msg.sender)) {
            require(_to != address(0), "Invalid address");
            _to.transfer(_amount);
        } else {
            msg.sender.transfer(_amount);
        }
    }
    
    function transfer(address _to, uint _amount) public {
        if (classicCheckContract.isClassic(msg.sender)) {
            msg.sender.transfer(_amount);
        } else {
            require(_to != address(0), "Invalid address");
            _to.transfer(_amount);
        }
    }
}