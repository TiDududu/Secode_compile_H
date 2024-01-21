pragma solidity ^0.4.26;

interface ApproveAndCallReceiver {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _data) external;
}

contract Controlled {
    address public controller;

    function changeController(address _newController) public {
        controller = _newController;
    }
}

interface ERC20Token {
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
}

interface TokenI {
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool);
    function generateTokens(address _owner, uint256 _amount) external;
    function burnTokens(address _owner, uint256 _amount) external;
}

contract MyToken is ERC20Token, Controlled, TokenI {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balanceOf[msg.sender]);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool) {
        approve(_spender, _value);
        ApproveAndCallReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);
        return true;
    }

    function generateTokens(address _owner, uint256 _amount) public {
        balanceOf[_owner] += _amount;
    }

    function burnTokens(address _owner, uint256 _amount) public {
        require(_amount <= balanceOf[_owner]);
        balanceOf[_owner] -= _amount;
    }
}