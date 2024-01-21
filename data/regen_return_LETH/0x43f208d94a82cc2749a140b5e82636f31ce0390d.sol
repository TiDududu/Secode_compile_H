pragma solidity ^0.4.26;

contract OraclizeI {
    function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32);
    function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32);
    function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) external payable returns (bytes32);
    function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32);
    function queryN(uint _timestamp, string _datasource, bytes _args) external payable returns (bytes32);
    function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _args, uint _gaslimit) external payable returns (bytes32);
    function getPrice(string _datasource) external view returns (uint);
    function getPrice(string _datasource, uint _gaslimit) external view returns (uint);
    function useCoupon(string _coupon) external;
    function setProofType(byte _proofType) external;
    function setConfig(string _config) external;
    function setCustomGasPrice(uint _gasPrice) external;
    function randomDS_getSessionPubKeyHash() external view returns (bytes32);
}

contract OraclizeAddrResolverI {
    function getAddress() public returns (address);
}

contract Oraclize is OraclizeI {
    OraclizeAddrResolverI OAR;

    function Oraclize() public {
        OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
    }

    modifier oraclizeAPI {
        _;
    }

    modifier coupon(string _coupon) {
        _;
    }

    function query(uint _timestamp, string _datasource, string _arg) external payable oraclizeAPI returns (bytes32) {
        return OAR.getAddress().call.value(msg.value)(bytes4(sha3("query(uint256,string,string)")), _timestamp, _datasource, _arg);
    }

    function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable oraclizeAPI returns (bytes32) {
        return OAR.getAddress().call.value(msg.value)(bytes4(sha3("query_withGasLimit(uint256,string,string,uint256)")), _timestamp, _datasource, _arg, _gaslimit);
    }

    function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) external payable oraclizeAPI returns (bytes32) {
        return OAR.getAddress().call.value(msg.value)(bytes4(sha3("query2(uint256,string,string,string)")), _timestamp, _datasource, _arg1, _arg2);
    }

    function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable oraclizeAPI returns (bytes32) {
        return OAR.getAddress().call.value(msg.value)(bytes4(sha3("query2_withGasLimit(uint256,string,string,string,uint256)")), _timestamp, _datasource, _arg1, _arg2, _gaslimit);
    }

    function queryN(uint _timestamp, string _datasource, bytes _args) external payable oraclizeAPI returns (bytes32) {
        return OAR.getAddress().call.value(msg.value)(bytes4(sha3("queryN(uint256,string,bytes)")), _timestamp, _datasource, _args);
    }

    function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _args, uint _gaslimit) external payable oraclizeAPI returns (bytes32) {
        return OAR.getAddress().call.value(msg.value)(bytes4(sha3("queryN_withGasLimit(uint256,string,bytes,uint256)")), _timestamp, _datasource, _args, _gaslimit);
    }

    function getPrice(string _datasource) external view returns (uint) {
        return OAR.getAddress().call(bytes4(sha3("getPrice(string)")), _datasource);
    }

    function getPrice(string _datasource, uint _gaslimit) external view returns (uint) {
        return OAR.getAddress().call(bytes4(sha3("getPrice(string,uint256)")), _datasource, _gaslimit);
    }

    function useCoupon(string _coupon) external coupon(_coupon) {
        OAR.getAddress().call(bytes4(sha3("useCoupon(string)")), _coupon);
    }

    function setProofType(byte _proofType) external {
        OAR.getAddress().call(bytes4(sha3("setProofType(byte)")), _proofType);
    }

    function setConfig(string _config) external {
        OAR.getAddress().call(bytes4(sha3("setConfig(string)")), _config);
    }

    function setCustomGasPrice(uint _gasPrice) external {
        OAR.getAddress().call(bytes4(sha3("setCustomGasPrice(uint256)")), _gasPrice);
    }

    function randomDS_getSessionPubKeyHash() external view returns (bytes32) {
        return OAR.getAddress().call(bytes4(sha3("randomDS_getSessionPubKeyHash()")));
    }
}