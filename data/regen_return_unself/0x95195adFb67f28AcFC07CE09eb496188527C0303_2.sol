pragma solidity ^0.4.26;

contract SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}

contract ERC223Interface {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public;
    function transfer(address to, uint256 value, bytes data) public;
    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
}

contract ERC223ReceivingContract {
    function tokenFallback(address _from, uint256 _value, bytes _data) public;
}

contract Ownership {
    address public owner;

    event LogOwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit LogOwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract Freezable is Ownership {
    bool public emergencyFreeze;
    mapping (address => bool) public frozen;

    event LogFreezed(address indexed target, bool frozen);
    event LogEmergencyFreezed(bool emergencyFreeze);

    function freezeAccount(address target, bool freeze) public onlyOwner {
        frozen[target] = freeze;
        emit LogFreezed(target, freeze);
    }

    function emergencyFreezeAllAccounts(bool freeze) public onlyOwner {
        emergencyFreeze = freeze;
        emit LogEmergencyFreezed(freeze);
    }
}

contract MyToken is ERC223Interface, Freezable {
    mapping(address => uint256) balances;
    uint256 totalSupply_;

    constructor(uint256 initialSupply) public {
        totalSupply_ = initialSupply;
        balances[msg.sender] = initialSupply;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function transfer(address to, uint256 value) public {
        require(to != address(0));
        require(value <= balances[msg.sender]);
        require(!frozen[msg.sender]);
        require(!frozen[to]);
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(msg.sender, to, value, "");
    }

    function transfer(address to, uint256 value, bytes data) public {
        require(to != address(0));
        require(value <= balances[msg.sender]);
        require(!frozen[msg.sender]);
        require(!frozen[to]);
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        if (isContract(to)) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
            receiver.tokenFallback(msg.sender, value, data);
        }
        emit Transfer(msg.sender, to, value, data);
    }

    function isContract(address _addr) private view returns (bool isContract) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
}