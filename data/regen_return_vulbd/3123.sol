pragma solidity ^0.4.26;

contract Owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function replaceOwner(address newOwner) public {
        require(msg.sender == owner);
        owner = newOwner;
    }

    function isOwner(address addr) public view returns (bool) {
        return addr == owner;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

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

    function pow(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b == 0) {
            return 1;
        }
        uint256 result = a;
        for (uint256 i = 1; i < b; i++) {
            result = mul(result, a);
        }
        return result;
    }
}

contract TokenDB is Owned {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;

    function transfer(address to, uint256 value) public {
        require(to != address(0));
        require(balances[msg.sender] >= value);
        balances[msg.sender] -= value;
        balances[to] += value;
    }

    function bulkTransfer(address[] to, uint256[] value) public {
        require(to.length == value.length);
        for (uint256 i = 0; i < to.length; i++) {
            transfer(to[i], value[i]);
        }
    }

    function setAllowance(address spender, uint256 value) public {
        allowance[msg.sender][spender] = value;
    }

    function getAllowance(address owner, address spender) public view returns (uint256) {
        return allowance[owner][spender];
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }
}

contract Token is Owned {
    using SafeMath for uint256;

    address public libAddress;
    address public dbAddress;
    address public icoAddress;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function changeLibAddress(address newAddress) public {
        require(isOwner(msg.sender));
        libAddress = newAddress;
    }

    function changeDBAddress(address newAddress) public {
        require(isOwner(msg.sender));
        dbAddress = newAddress;
    }

    function changeIcoAddress(address newAddress) public {
        require(isOwner(msg.sender));
        icoAddress = newAddress;
    }

    function approve(address spender, uint256 value) public {
        setAllowance(msg.sender, spender, value);
        emit Approval(msg.sender, spender, value);
    }

    function transfer(address to, uint256 value) public {
        TokenDB(dbAddress).transfer(to, value);
        emit Transfer(msg.sender, to, value);
    }

    function bulkTransfer(address[] to, uint256[] value) public {
        TokenDB(dbAddress).bulkTransfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(value <= allowance[from][msg.sender]);
        allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        TokenDB(dbAddress).transfer(to, value);
        emit Transfer(from, to, value);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return TokenDB(dbAddress).getAllowance(owner, spender);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return TokenDB(dbAddress).balanceOf(owner);
    }
}

contract Ico is Owned {
    enum PhaseType { PreSale, PublicSale }
    PhaseType public currentPhase;
    uint256 public currentRate;
    mapping(address => bool) public KYC;
    mapping(address => bool) public transferRight;
    mapping(address => uint256) public vesting;

    function phaseType() public view returns (PhaseType) {
        return currentPhase;
    }

    function vesting_s(address investor) public view returns (uint256) {
        return vesting[investor];
    }

    function currentPhase() public view returns (PhaseType) {
        return currentPhase;
    }

    function currentRate() public view returns (uint256) {
        return currentRate;
    }

    function KYC(address investor) public view returns (bool) {
        return KYC[investor];
    }

    function transferRight(address investor) public view returns (bool) {
        return transferRight[investor];
    }
}