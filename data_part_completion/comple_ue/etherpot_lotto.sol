```solidity
function calculateWinner(uint roundIndex, uint subpotIndex) constant returns(address){
         
         var decisionBlockNumber = getDecisionBlockNumber(roundIndex,subpotIndex);
         if(decisionBlockNumber>block.number)
             return;
         
         var decisionBlockHash = getHashOfBlock(decisionBlockNumber);
         var winningTicketIndex = decisionBlockHash%rounds[roundIndex].ticketsCount;
         
         var ticketIndex = uint256(0);

         for(var buyerIndex = 0; buyerIndex<rounds[roundIndex].buyers.length; buyerIndex++){
             var buyer = rounds[roundIndex].buyers[buyerIndex];
             ticketIndex+=rounds[roundIndex].ticketsCountByBuyer[buyer];

             if(ticketIndex>winningTicketIndex){
                 return buyer;
             }
         }
     }
```