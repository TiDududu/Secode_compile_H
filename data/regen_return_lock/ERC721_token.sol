pragma solidity ^0.4.26;

contract ERC721 {
    mapping (uint256 => address) private tokenOwner;
    mapping (address => uint256) private ownedTokensCount;
    mapping (uint256 => address) private tokenApproval;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event Create(uint256 indexed tokenId, string name, string dna);

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0));
        return ownedTokensCount[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = tokenOwner[tokenId];
        require(owner != address(0));
        return owner;
    }

    function transfer(address to, uint256 tokenId) public {
        address from = msg.sender;
        address owner = ownerOf(tokenId);
        require(owner == from);
        require(to != address(0));
        _transfer(from, to, tokenId);
    }

    function create(uint256 tokenId, string name, string dna) public {
        require(tokenOwner[tokenId] == address(0));
        tokenOwner[tokenId] = msg.sender;
        ownedTokensCount[msg.sender]++;
        emit Create(tokenId, name, dna);
    }

    function approve(address approved, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner || msg.sender == getApproved(tokenId));
        tokenApproval[tokenId] = approved;
        emit Approval(owner, approved, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        tokenOwner[tokenId] = to;
        ownedTokensCount[from]--;
        ownedTokensCount[to]++;
        emit Transfer(from, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        return tokenApproval[tokenId];
    }
}