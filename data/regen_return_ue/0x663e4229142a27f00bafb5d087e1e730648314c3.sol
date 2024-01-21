pragma solidity ^0.4.26;

contract ERC20 {
    function totalSupply() public view returns (uint);
    function balanceOf(address who) public view returns (uint);
    function allowance(address owner, address spender) public view returns (uint);
    function transfer(address to, uint value) public returns (bool);
    function transferFrom(address from, address to, uint value) public returns (bool);
    function approve(address spender, uint value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }
}

contract ERC721 {
    function totalSupply() public view returns (uint);
    function balanceOf(address _owner) public view returns (uint);
    function ownerOf(uint256 _tokenId) public view returns (address);
    function approve(address _to, uint256 _tokenId) public;
    function transfer(address _to, uint256 _tokenId) public;
    function transferFrom(address _from, address _to, uint256 _tokenId) public;
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
}

contract GeneScienceInterface {
    function isGeneScience() public view returns (bool);
    function mixGenes(uint256[2] genes1, uint256[2] genes2, uint256 g1, uint256 g2, uint256 targetBlock) public returns (uint256[2]);
    function getPureFromGene(uint256[2] gene) public view returns (uint256);
    function getSex(uint256[2] gene) public view returns (uint256);
    function getWizzType(uint256[2] gene) public view returns (uint256);
    function clearWizzType(uint256[2] _gene) public returns (uint256[2]);
}

contract PandaAccessControl is Ownable {
    mapping (address => bool) public cfoAddress;
    mapping (address => bool) public cooAddress;
    mapping (address => bool) public ceoAddress;
    bool public paused = false;

    modifier onlyCLevel() {
        require(msg.sender == owner || msg.sender == address(this) || cfoAddress[msg.sender] || cooAddress[msg.sender] || ceoAddress[msg.sender]);
        _;
    }

    function setCOO(address _newCOO) public onlyOwner {
        require(_newCOO != address(0));
        cooAddress[_newCOO] = true;
    }

    function setCEO(address _newCEO) public onlyOwner {
        require(_newCEO != address(0));
        ceoAddress[_newCEO] = true;
    }

    function setCFO(address _newCFO) public onlyOwner {
        require(_newCFO != address(0));
        cfoAddress[_newCFO] = true;
    }

    function pause() public onlyCLevel {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }
}