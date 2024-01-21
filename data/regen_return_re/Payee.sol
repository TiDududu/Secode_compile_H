pragma solidity ^0.4.26;

contract Storage {
    address public founder;
    bool public changeable;
    mapping(address => bool) public admins;
    mapping(address => uint256) public userData;

    constructor() public {
        founder = msg.sender;
        admins[founder] = true;
        changeable = true;
    }

    function update(address user, uint256 newData) public {
        require(admins[msg.sender] && changeable);
        userData[user] = newData;
    }

    function set(address user, uint256 data) public {
        require(admins[msg.sender] && changeable);
        userData[user] = data;
    }

    function admin(address user, bool status) public {
        require(msg.sender == founder);
        admins[user] = status;
    }

    function halt(bool status) public {
        require(msg.sender == founder);
        changeable = status;
    }

    function() external {
        revert();
    }
}

contract Payee {
    address public founder;
    bool public changeable;
    address public storageAddress;
    uint256 public defaultPrice;
    mapping(address => bool) public admins;

    event Buy(address indexed buyer, uint256 price);

    constructor(address _storageAddress, uint256 _defaultPrice) public {
        founder = msg.sender;
        admins[founder] = true;
        changeable = true;
        storageAddress = _storageAddress;
        defaultPrice = _defaultPrice;
    }

    function setPrice(uint256 newPrice) public {
        require(admins[msg.sender] && changeable);
        defaultPrice = newPrice;
    }

    function setStorageAddress(address newStorageAddress) public {
        require(admins[msg.sender] && changeable);
        storageAddress = newStorageAddress;
    }

    function admin(address user, bool status) public {
        require(msg.sender == founder);
        admins[user] = status;
    }

    function halt(bool status) public {
        require(msg.sender == founder);
        changeable = status;
    }

    function pay(address user, uint256 price) public {
        require(price > 0);
        require(Storage(storageAddress).userData(user) == price);
        Storage(storageAddress).update(user, 0);
        emit Buy(user, price);
    }

    function() external payable {
        revert();
    }
}