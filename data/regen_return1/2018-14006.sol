pragma solidity ^0.4.26;

contract ERC20 {
    string public name = "NEO Genesis Token";
    string public symbol = "NGT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    function decimals() public view returns (uint8) {
        return decimals;
    }
    
    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balanceOf[_owner];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));
        require(balanceOf[msg.sender] >= _value);
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function multipleTransfer(address[] _to, uint256[] _values) public returns (bool success) {
        require(_to.length == _values.length);
        
        for (uint i = 0; i < _to.length; i++) {
            require(_to[i] != address(0));
            require(balanceOf[msg.sender] >= _values[i]);
            
            balanceOf[msg.sender] -= _values[i];
            balanceOf[_to[i]] += _values[i];
            emit Transfer(msg.sender, _to[i], _values[i]);
        }
        return true;
    }
    
    function batchTransfer(address[] _to, uint256[] _values) public returns (bool success) {
        require(_to.length == _values.length);
        
        for (uint i = 0; i < _to.length; i++) {
            require(_to[i] != address(0));
            
            balanceOf[msg.sender] -= _values[i];
            balanceOf[_to[i]] += _values[i];
            emit Transfer(msg.sender, _to[i], _values[i]);
        }
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        // Missing line
    }
}

contract ERC223 is ERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
    
    function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
        require(_to != address(0));
        require(balanceOf[msg.sender] >= _value);
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        if (isContract(_to)) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        emit Transfer(msg.sender, _to, _value, _data);
        return true;
    }
    
    function isContract(address _addr) private view returns (bool is_contract) {
        uint length;
        assembly {
            length := extcodesize(_addr)
        }
        return (length > 0);
    }
}

contract ERC223ReceivingContract {
    function tokenFallback(address _from, uint256 _value, bytes _data) public;
}