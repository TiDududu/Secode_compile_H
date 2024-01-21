pragma solidity ^0.8.0;

interface ERC20 {
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function transfer(address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
}

contract TokenHandler {
    address public controller;

    modifier onlyController {
        require(msg.sender == controller, "Only controller can access this function");
        _;
    }

    constructor() {
        controller = msg.sender;
    }

    function changeController(address newController) public onlyController {
        controller = newController;
    }

    function receiveApproval(address _from, uint _value, address _token, bytes memory _extraData) public {
        require(_token == address(this), "Token address does not match contract address");
        ERC20 token = ERC20(_token);
        token.transferFrom(_from, address(this), _value);
        emit Transfer(_from, address(this), _value);
    }

    function transfer(address _token, address _to, uint _value) public onlyController {
        ERC20 token = ERC20(_token);
        token.transfer(_to, _value);
        emit Transfer(address(this), _to, _value);
    }

    function transferFrom(address _token, address _from, address _to, uint _value) public onlyController {
        ERC20 token = ERC20(_token);
        token.transferFrom(_from, _to, _value);
        emit Transfer(_from, _to, _value);
    }

    function approve(address _token, address _spender, uint _value) public onlyController {
        ERC20 token = ERC20(_token);
        token.approve(_spender, _value);
        emit Approval(address(this), _spender, _value);
    }

    function allowance(address _token, address _owner, address _spender) public view returns (uint) {
        ERC20 token = ERC20(_token);
        return token.allowance(_owner, _spender);
    }

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}