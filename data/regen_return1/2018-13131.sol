pragma solidity ^0.4.26;

contract StandardToken {
  mapping (address => mapping (address => uint256)) allowed;
  event Approval(address indexed owner, address indexed spender, uint256 value);
  function transfer(address _to, uint256 _value) public returns (bool) {}
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {}
}

contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;

  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    return true;
  }

  function finishMinting() public onlyOwner returns (bool) {
    mintingFinished = true;
    MintFinished();
    return true;
  }
}

contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}

contract MyToken is MintableToken {
  string public name = "MyToken";
  string public symbol = "MT";
  uint8 public decimals = 18;
}