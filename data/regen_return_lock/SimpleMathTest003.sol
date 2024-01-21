pragma solidity ^0.4.26;

contract MathCalculator {
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    function mul(uint a, uint b) public pure returns (uint) {
        return a * b;
    }

    function div(uint a, uint b) public pure returns (uint) {
        return a / b;
    }

    function sub(uint a, uint b) public pure returns (uint) {
        require(a >= b, "Subtraction result cannot be negative");
        return a - b;
    }
}