pragma solidity ^0.4.26;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
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
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract TokenCHK {
    function balanceOf(address owner) public view returns (uint256);
}

contract ESSENTIA_PE is Ownable {
    using SafeMath for uint256;

    TokenCHK public token;
    address public FWDaddrETH;
    address public genesis;
    uint256 public maxCap;
    uint256 public price;
    uint256 public pubEnd;

    mapping(address => uint256) public balances;

    event TokensPurchased(address indexed buyer, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event EmergencyWithdrawal(address indexed owner, uint256 amount);

    function setFWDaddrETH(address _addr) public onlyOwner {
        FWDaddrETH = _addr;
    }

    function setGenesis(address _addr) public onlyOwner {
        genesis = _addr;
    }

    function setMaxCap(uint256 _cap) public onlyOwner {
        maxCap = _cap;
    }

    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    function setPubEnd(uint256 _endTime) public onlyOwner {
        pubEnd = _endTime;
    }

    function buy() public payable {
        require(now < pubEnd, "Public sale has ended");
        uint256 amount = msg.value.div(price);
        require(balances[msg.sender].add(amount) <= maxCap, "Exceeds maximum cap");
        transferBuy(msg.sender, amount);
        emit TokensPurchased(msg.sender, amount);
    }

    function withdrawPUB() public {
        require(now > pubEnd, "Public sale has not ended");
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No tokens to withdraw");
        balances[msg.sender] = 0;
        token.transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    function EMGwithdraw(uint256 _amount) public onlyOwner {
        require(now > pubEnd, "Public sale has not ended");
        require(_amount <= address(this).balance, "Insufficient balance");
        payable(FWDaddrETH).transfer(_amount);
        emit EmergencyWithdrawal(owner, _amount);
    }

    function transferBuy(address _buyer, uint256 _amount) internal {
        uint256 cost = _amount.mul(price);
        require(msg.value >= cost, "Insufficient Ether sent");
        balances[_buyer] = balances[_buyer].add(_amount);
    }
}
