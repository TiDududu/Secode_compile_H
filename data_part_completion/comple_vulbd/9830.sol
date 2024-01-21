```solidity
    function GetPVPData(address addr) public constant returns (uint256 attackpower, uint256 defensepower, uint256 immunityTime, uint256 exhaustTime, uint256[6] troops) {
        attackpower = pvpMap[addr].troops[0] * troopData[0].attackPower + pvpMap[addr].troops[1] * troopData[1].attackPower + pvpMap[addr].troops[2] * troopData[2].attackPower;
        defensepower = pvpMap[addr].troops[3] * troopData[3].defensePower + pvpMap[addr].troops[4] * troopData[4].defensePower + pvpMap[addr].troops[5] * troopData[5].defensePower;
        immunityTime = pvpMap[addr].immunityTime;
        exhaustTime = pvpMap[addr].exhaustTime;
        for (uint8 i = 0; i < 6; i++) {
            troops[i] = pvpMap[addr].troops[i];
        }
    }
}
```