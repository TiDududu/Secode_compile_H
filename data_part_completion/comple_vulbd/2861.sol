);
  }
   
  function vestedAmount(address _beneficiary) public view returns (uint256) {
    tokenToVest storage value = vestToMap[_beneficiary];
    if (!value.exist) {
      return 0;
    } else if (block.timestamp < value.start.add(value.cliff)) {
      return 0;
    } else if (block.timestamp >= value.start.add(value.duration)) {
      return value.torelease;
    } else {
      uint256 vestingTime = block.timestamp.sub(value.start);
      uint256 vested = vestingTime.mul(value.torelease).div(value.duration);
      return vested;
    }
  }
}