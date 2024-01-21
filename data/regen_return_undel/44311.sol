pragma solidity ^0.4.26;

contract DelegateCaller {
    function delegatecallSetN(address _contract, uint _n) public {
        require(_contract != address(0), "Invalid contract address");
        
        bool success;
        bytes memory data = abi.encodeWithSignature("setN(uint256)", _n);
        assembly {
            success := delegatecall(gas, _contract, add(data, 0x20), mload(data), 0, 0)
            switch success
            case 0 {
                revert(0, 0)
            }
        }
    }
}

contract AnotherContract {
    uint public n;
    
    function setN(uint _n) public {
        n = _n;
    }
}