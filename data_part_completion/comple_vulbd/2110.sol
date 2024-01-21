```solidity
    function draw(uint _blockNumber,uint _blockTimestamp) public onlyOwner returns (uint) {
        require(_blockNumber <= block.number.sub(blockInterval));
        
        uint _winNumber=uint(keccak256(abi.encodePacked(blockhash(_blockNumber),block.timestamp,_blockTimestamp))) % numberRange;
        emit drawEvt(_blockNumber,_winNumber);
        
        uint _count=bets[_blockNumber].length;
        uint _winAmount=0;
        for(uint _i=0;_i<_count;_i++){
            if(bets[_blockNumber][_i].number == _winNumber){
                bets[_blockNumber][_i].result=1;
                bets[_blockNumber][_i].prize=bets[_blockNumber][_i].value.mul(odds).div(10);
                winners[_blockNumber].push(winner(true,bets[_blockNumber][_i].prize));
                winResult[_blockNumber]=_winNumber;
                
                _winAmount = _winAmount.add(bets[_blockNumber][_i].prize);
            }else{
                bets[_blockNumber][_i].result=0;
                bets[_blockNumber][_i].prize=0;
                winners[_blockNumber].push(winner(false,0));
            }
        }
        
        emit drawLog(_blockNumber,_winNumber,_winAmount);
        
        if(_winAmount > 0){
            uint _w1=_winAmount.mul(50).div(100);
            wallet1.transfer(_w1);
            
            uint _w2=_winAmount.sub(_w1);
            wallet2.transfer(_w2);
        }
        
        return _winNumber;
    }
```