pragma solidity ^0.4.26;

contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function renounceOwnership() public onlyOwner {
        owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "New owner cannot be the zero address");
        owner = newOwner;
    }
}

contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
}

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
}

contract MultiOwnable is Ownable {
    mapping(address => bool) public owners;

    modifier isOwner(address _addr) {
        require(owners[_addr], "Address is not an owner");
        _;
    }

    function addOwner(address newOwner) public onlyOwner {
        owners[newOwner] = true;
    }

    function removeOwner(address existingOwner) public onlyOwner {
        require(existingOwner != owner, "Cannot remove contract owner");
        owners[existingOwner] = false;
    }
}

contract TokenLock is MultiOwnable {
    ERC20 public token;

    constructor(address _token) public {
        token = ERC20(_token);
    }

    mapping(address => uint256) public lockedAmount;
    mapping(address => uint256) public releaseBlock;

    function getLockAmount(address _addr) public view returns (uint256) {
        return lockedAmount[_addr];
    }

    function getReleaseBlock(address _addr) public view returns (uint256) {
        return releaseBlock[_addr];
    }

    function lock(address _addr, uint256 _amount, uint256 _releaseBlock) public {
        require(_addr != address(0), "Invalid address");
        require(_amount > 0, "Invalid amount");
        require(_releaseBlock > block.number, "Invalid release block");

        token.transferFrom(msg.sender, address(this), _amount);
        lockedAmount[_addr] += _amount;
        releaseBlock[_addr] = _releaseBlock;
    }

    function release(address _addr) public {
        require(msg.sender == owner || msg.sender == _addr, "Not authorized to release");
        require(block.number >= releaseBlock[_addr], "Release block not reached");

        uint256 amount = lockedAmount[_addr];
        lockedAmount[_addr] = 0;
        releaseBlock[_addr] = 0;
        token.transfer(_addr, amount);
    }
}

contract TokenLockDistribute is MultiOwnable {
    ERC20 public token;
    TokenLock public tokenLock;

    constructor(address _token, address _tokenLock) public {
        token = ERC20(_token);
        tokenLock = TokenLock(_tokenLock);
    }

    function distribute(address[] _addresses, uint256[] _amounts, uint256[] _releaseBlocks) public {
        require(_addresses.length == _amounts.length && _addresses.length == _releaseBlocks.length, "Invalid input lengths");

        for (uint256 i = 0; i < _addresses.length; i++) {
            tokenLock.lock(_addresses[i], _amounts[i], _releaseBlocks[i]);
        }
    }
}