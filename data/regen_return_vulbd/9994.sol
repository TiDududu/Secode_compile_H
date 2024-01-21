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

library AddressUtils {
    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}

contract Ownable {
    address public owner;
    address public admin;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event AdminSet(address indexed previousAdmin, address indexed newAdmin);

    constructor() public {
        owner = msg.sender;
        admin = msg.sender;
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

    function setAdmin(address newAdmin) public onlyOwner {
        emit AdminSet(admin, newAdmin);
        admin = newAdmin;
    }
}

contract Pausable is Ownable {
    bool public paused;

    event Paused(address account);
    event Unpaused(address account);

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    modifier whenPaused() {
        require(paused);
        _;
    }

    function pause() public onlyOwner whenNotPaused {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner whenPaused {
        paused = false;
        emit Unpaused(msg.sender);
    }
}

contract BrokenContract is Pausable {
    address public newContractAddress;

    event NewContract(address indexed newAddress);

    function setNewContractAddress(address _newAddress) public onlyOwner {
        newContractAddress = _newAddress;
        emit NewContract(_newAddress);
    }
}

interface ERC721Basic {
    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
    function exists(uint256 tokenId) external view returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
}

interface ERC721Enumerable {
    function totalSupply() external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
    function tokenByIndex(uint256 index) external view returns (uint256);
}

interface ERC721Metadata {
    function name() external view returns (string);
    function symbol() external view returns (string);
    function tokenURI(uint256 tokenId) external view returns (string);
}

contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

contract ERC721BasicToken is BrokenContract, ERC721Basic {
    using SafeMath for uint256;

    mapping (address => uint256) internal balances;
    mapping (uint256 => address) internal tokenOwner;
    mapping (uint256 => bool) internal exists;

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        require(exists[tokenId]);
        return tokenOwner[tokenId];
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return exists[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
        require(to != address(0));
        require(to != address(this));
        require(_isApprovedOrOwner(msg.sender, tokenId));
        _clearApproval(tokenId);
        _removeToken(from, tokenId);
        _addToken(to, tokenId);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner);
    }

    function _clearApproval(uint256 tokenId) internal {
        if (tokenApprovals[tokenId] != address(0)) {
            delete tokenApprovals[tokenId];
        }
    }

    function _removeToken(address from, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from);
        balances[from] = balances[from].sub(1);
        delete tokenOwner[tokenId];
    }

    function _addToken(address to, uint256 tokenId) internal {
        require(tokenOwner[tokenId] == address(0));
        tokenOwner[tokenId] = to;
        balances[to] = balances[to].add(1);
    }
}