pragma solidity ^0.4.26;

contract LANDStorage {
    mapping(address => uint256) public latestPing;
    uint256 constant internal IS_APPROVED_FOR_ALL = 1 << 30;
    uint256 constant internal IS_OWNER = 1 << 31;
}

contract AssetRegistryStorage {
    struct Asset {
        string name;
        string description;
        uint256 count;
        address owner;
        mapping(address => bool) operators;
    }
    mapping(uint256 => Asset) public assets;
}

contract OwnableStorage {
    address public owner;
}

contract ProxyStorage {
    address internal currentContract;
}

contract Storage is ProxyStorage, OwnableStorage, AssetRegistryStorage, LANDStorage {
}

contract DelegateProxy {
    function isContract(address _target) internal view returns (bool);
    function delegate(address _implementation);
}

interface IApplication {
    function initialize() external;
}

contract Proxy is ProxyStorage {
    function upgradeTo(address newImplementation) external;
    function () payable external {
        address _impl = currentContract;
        require(_impl != address(0));
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
            returndatacopy(ptr, 0, returndatasize)
            switch result
            case 0 {revert(ptr, returndatasize)}
            default {return (ptr, returndatasize)}
        }
    }
}

contract LANDProxy is Storage, Proxy {
}