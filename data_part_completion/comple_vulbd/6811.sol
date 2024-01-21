```solidity
  function verifyXTVSignature(bytes32 hash, bytes memory signature) public view returns (bool) {
    address signerAddress = XTVNetworkUtils.verifyXTVSignatureAddress(hash, signature);
    return xtvNetworkEndorser[signerAddress];
  }

  function setXTVNetworkEndorser(address _addr, bool isEndorser) public onlyOwner {
    xtvNetworkEndorser[_addr] = isEndorser;
  }
}
```