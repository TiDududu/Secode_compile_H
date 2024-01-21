pragma solidity ^0.4.26;

contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public {
        require(newOwner != address(0));
        require(msg.sender == owner);
        owner = newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == owner);
        owner = msg.sender;
    }
}

contract Pausable is Ownable {
    bool public paused;

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
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

library ContractLib {
    function isContract(address _addr) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
}

interface ERC20Interface {
    function transfer(address _to, uint256 _value) external returns (bool);
}

contract ERC223 is ERC20Interface {
    function transfer(address _to, uint256 _value, bytes _data) public returns (bool);
}

contract NXX is ERC223, Pausable {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) balances;

    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }

    function name() public view returns (string) {
        return name;
    }

    function symbol() public view returns (string) {
        return symbol;
    }

    function decimals() public view returns (uint8) {
        return decimals;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        uint codeLength;
        assembly {
            codeLength := extcodesize(_to)
        }

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        if (codeLength > 0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        emit Transfer(msg.sender, _to, _value, _data);
        return true;
    }
}