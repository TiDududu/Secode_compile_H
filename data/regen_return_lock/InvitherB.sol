pragma solidity ^0.4.26;

contract NetworkManager {
    address public owner;
    bool public contractLocked;
    uint public userCount;
    uint public rewardThreshold;
    
    struct User {
        uint id;
        address userAddress;
        uint parentUserId;
    }
    
    mapping(uint => User) public users;
    
    event UserAdded(uint userId, address userAddress, uint parentUserId);
    event UserRewarded(uint userId, address userAddress, uint rewardAmount);
    
    constructor() public {
        owner = msg.sender;
        contractLocked = false;
        userCount = 0;
        rewardThreshold = 10;
        _addUser(0); // Initializing the contract by setting up the first user as the owner
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    modifier contractNotLocked() {
        require(!contractLocked, "Contract is locked");
        _;
    }
    
    function transferOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
    
    function setContractLock(bool lockState) public onlyOwner {
        contractLocked = lockState;
    }
    
    function _addUser(uint parentUserId) private contractNotLocked {
        userCount++;
        users[userCount] = User(userCount, msg.sender, parentUserId);
        emit UserAdded(userCount, msg.sender, parentUserId);
    }
    
    function getRewarder(uint userId) public view returns (uint) {
        uint currentUserId = userId;
        uint parentUserId = users[currentUserId].parentUserId;
        uint level = 1;
        
        while (parentUserId != 0) {
            if (level % rewardThreshold == 0) {
                return currentUserId;
            }
            currentUserId = parentUserId;
            parentUserId = users[currentUserId].parentUserId;
            level++;
        }
        
        return 0;
    }
    
    function getUserCount() public view returns (uint) {
        return userCount;
    }
    
    function getUser(uint userId) public view returns (uint, address, uint) {
        return (users[userId].id, users[userId].userAddress, users[userId].parentUserId);
    }
    
    function addUser(uint parentUserId) public payable contractNotLocked {
        require(msg.value == 1 ether, "Insufficient payment");
        _addUser(parentUserId);
    }
}