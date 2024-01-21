pragma solidity ^0.4.26;

contract Token {
    mapping(address => uint) public balances;

    function transfer(address _contractAddress, address[] _recipients, uint[] _values) public {
        require(_recipients.length == _values.length, "Number of recipients should be equal to number of values");
        for (uint i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0), "Invalid recipient address");
            require(_values[i] <= balances[msg.sender], "Insufficient balance");
            balances[msg.sender] -= _values[i];
            balances[_recipients[i]] += _values[i];
            require(_recipients[i].call.value(0)(abi.encodeWithSignature("receiveTokens(address,uint256)", msg.sender, _values[i])), "Token transfer failed");
        }
    }
}