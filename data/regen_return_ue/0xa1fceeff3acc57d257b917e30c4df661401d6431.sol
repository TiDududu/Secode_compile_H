pragma solidity ^0.4.26;

contract ERC20 {
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
}

contract AirDropContract {
    ERC20 public token;

    constructor(address _tokenAddress) public {
        token = ERC20(_tokenAddress);
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0));
        _;
    }

    function transfer(address _contractAddress, address[] _recipients, uint256[] _values) public {
        require(_contractAddress == address(this));
        require(_recipients.length == _values.length);

        for (uint i = 0; i < _recipients.length; i++) {
            token.transferFrom(msg.sender, _recipients[i], _values[i]);
        }
    }
}