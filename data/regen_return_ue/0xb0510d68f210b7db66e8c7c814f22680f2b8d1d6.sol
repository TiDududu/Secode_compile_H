pragma solidity ^0.4.26;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
}

contract Puppet {
    address public master;

    constructor() public {
        master = msg.sender;
    }

    function() public payable {
        address target = 0x123; // Replace with the specified target address
        target.transfer(msg.value);
    }

    function withdraw() public {
        require(msg.sender == master, "Only the master can withdraw");
        msg.sender.transfer(address(this).balance);
    }
}

contract Splitter {
    using SafeMath for uint256;

    address public owner;
    mapping(uint256 => address) public puppets;
    mapping(address => bool) public extra;

    constructor() public {
        owner = msg.sender;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw");
        msg.sender.transfer(address(this).balance);
    }

    function getPuppetCount() public view returns (uint256) {
        return puppets.length;
    }

    function newPuppet() public {
        address puppet = address(new Puppet());
        puppets[getPuppetCount()] = puppet;
    }

    function setExtra(address _address, bool _isExtra) public {
        require(msg.sender == owner, "Only the owner can set extra");
        extra[_address] = _isExtra;
    }

    function fundPuppets(uint256[] memory amounts) public {
        require(amounts.length == getPuppetCount(), "Invalid amounts length");
        for (uint256 i = 0; i < amounts.length; i++) {
            address puppet = puppets[i];
            require(puppet != address(0), "Invalid puppet address");
            if (extra[puppet]) {
                puppet.transfer(amounts[i].div(2));
            } else {
                puppet.transfer(amounts[i]);
            }
        }
    }

    function() public payable {}
}