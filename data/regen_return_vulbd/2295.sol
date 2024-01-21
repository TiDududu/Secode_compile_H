pragma solidity ^0.4.26;

contract ERC20 {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
}

library SafeMath {
    function mul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        require(b > 0);
        uint c = a / b;
        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a);
        return a - b;
    }
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a);
        return c;
    }
}

contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract WrapperLock is Ownable {
    using SafeMath for uint;

    ERC20 public token;
    mapping(address => uint) public lockedUntil;

    constructor(address _token) public {
        token = ERC20(_token);
    }

    function deposit(uint amount, uint lockDuration) public {
        require(token.transferFrom(msg.sender, address(this), amount));
        lockedUntil[msg.sender] = now.add(lockDuration);
    }

    function withdraw(uint amount) public {
        require(lockedUntil[msg.sender] <= now);
        lockedUntil[msg.sender] = 0;
        require(token.transfer(msg.sender, amount));
    }

    function totalSupply() public view returns (uint) {
        return token.totalSupply();
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return token.balanceOf(tokenOwner);
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        return token.transfer(to, tokens);
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return token.allowance(tokenOwner, spender);
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        return token.transferFrom(from, to, tokens);
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        return token.approve(spender, tokens);
    }
}