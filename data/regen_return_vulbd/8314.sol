pragma solidity ^0.4.26;

interface TokenContract {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address owner) external view returns (uint256);
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

contract Vault is Ownable, TokenContract {
    struct TeamMember {
        address memberAddress;
        uint256 allocation;
    }

    TokenContract public tokenContract;
    TeamMember[] public team;

    constructor(address _tokenContract) public {
        tokenContract = TokenContract(_tokenContract);
    }

    function releaseTokens() public onlyOwner {
        uint256 totalTokens = tokenContract.balanceOf(address(this));
        for (uint i = 0; i < team.length; i++) {
            require(tokenContract.transfer(team[i].memberAddress, team[i].allocation), "Vault: token transfer failed");
            totalTokens -= team[i].allocation;
        }
        require(tokenContract.transfer(owner, totalTokens), "Vault: token transfer to owner failed");
        selfdestruct(owner);
    }

    function addMembers(address _memberAddress, uint256 _allocation) public onlyOwner {
        team.push(TeamMember(_memberAddress, _allocation));
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(msg.sender == owner, "Vault: caller is not the owner");
        return tokenContract.transfer(to, value);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return tokenContract.balanceOf(owner);
    }
}