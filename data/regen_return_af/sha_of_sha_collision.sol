pragma solidity ^0.4.26;

contract ValueStorage {
    mapping(bytes32 => uint) private m;

    function set(uint input) public {
        bytes32 key = keccak256(abi.encodePacked("A", input));
        m[key] = 1;
    }

    function check(uint input) public view {
        bytes32 key = keccak256(abi.encodePacked(input, "B"));
        assert(m[key] == 0);
    }
}