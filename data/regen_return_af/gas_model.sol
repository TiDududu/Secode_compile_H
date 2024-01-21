pragma solidity ^0.4.26;

contract GasChecker {
    function check() public view returns (bool) {
        uint256 gasBefore = gasleft();
        // Perform a simple operation
        uint256 a = 1;
        uint256 b = 2;
        uint256 c = a + b;
        uint256 gasAfter = gasleft();
        assert(gasAfter > gasBefore);
        return true;
    }
}