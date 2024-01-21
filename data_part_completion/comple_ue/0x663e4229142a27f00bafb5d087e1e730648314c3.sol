```solidity
            cooldownIndex = cooldownIndex%10 + 5;
            }
                }
        
                Panda memory _panda = Panda({
            genes: _genes,
            birthTime: uint64(now),
            cooldownEndBlock: 0,
            matronId: uint32(_matronId),
            sireId: uint32(_sireId),
            siringWithId: 0,
            cooldownIndex: cooldownIndex,
            generation: uint16(_generation)
        });
        uint256 newPandaId = pandas.push(_panda) - 1;

                require(newPandaId == uint256(uint32(newPandaId)));

                birthWithId(_owner,newPandaId,_matronId,_sireId,_genes);

                _transfer(0, _owner, newPandaId);

                gen0CreatedCount++;

                return newPandaId;
    }
```
Only the missing part is shown above.