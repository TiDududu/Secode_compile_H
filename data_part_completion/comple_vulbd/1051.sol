```solidity
unction totalMaxFreezingLccs(address addr, uint8 freezing_type) constant public returns (uint) {
        FreezingNode[] memory nodes = c_freezing_list[addr];
        uint length = nodes.length;
        uint total_lccs = 0;

        for (uint i = 0; i < length; ++i) {
            if (nodes[i].freezing_type == freezing_type && nodes[i].end_stamp > block.timestamp) {
                total_lccs = add(total_lccs, nodes[i].num_lccs);
            }
        }

        return total_lccs;
    }

    function updateMultipleFreezings(address addr, uint[] end_stamps, uint[] num_lccs, uint8[] freezing_types) auth public {
        require(end_stamps.length == num_lccs.length && end_stamps.length == freezing_types.length);

        for (uint i = 0; i < end_stamps.length; ++i) {
            updateFreezing(addr, end_stamps[i], num_lccs[i], freezing_types[i]);
        }
    }

     
     
    function setFreezing(address addr, uint end_stamp, uint num_lccs, uint8 freezing_type) auth public {
        require(num_lccs <= balanceOf(addr));
        require(freezing_type < 100);  
        require(c_freezing_list[addr].length < 300);  

        if (num_lccs > 0) {
            c_freezing_list[addr].push(FreezingNode(end_stamp, num_lccs, freezing_type));
            emit SetFreezingEvent(addr, end_stamp, num_lccs, freezing_type);
        }
    }

     
    function updateFreezing(address addr, uint end_stamp, uint num_lccs, uint8 freezing_type) auth public {
        require(num_lccs <= balanceOf(addr));
        require(freezing_type < 100);  

        uint i = 0;
        FreezingNode[] storage nodes = c_freezing_list[addr];
        while (i < nodes.length) {
            if (nodes[i].freezing_type == freezing_type && nodes[i].end_stamp <= block.timestamp) {  
                nodes[i] = nodes[nodes.length - 1];
                nodes.length--;
            } else {
                i++;
            }
        }

        if (num_lccs > 0) {
            nodes.push(FreezingNode(end_stamp, num_lccs, freezing_type));
            emit SetFreezingEvent(addr, end_stamp, num_lccs, freezing_type);
        }
    }

     
    function freezingBalanceOf(address addr) constant public returns (uint) {
        FreezingNode[] memory nodes = c_freezing_list[addr];
        uint length = nodes.length;
        uint total_lccs = 0;

        for (uint i = 0; i < length; ++i) {
            if (nodes[i].end_stamp > block.timestamp) {
                total_lccs = add(total_lccs, nodes[i].num_lccs);
            }
        }

        return total_lccs;
    }

     
    function maxFreezingLccs(address addr) constant public returns (uint) {
        return totalMaxFreezingLccs(addr, 0);
    }

     
    function validBalanceOfWithFreezing(address addr) constant public returns (uint) {
        return validBalanceOf(addr) + freezingBalanceOf(addr);
    }
}
```