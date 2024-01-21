```solidity
function claimThrone(string name) payable {
        require(msg.value >= currentClaimPrice);
        uint excess = msg.value - currentClaimPrice;
        uint commission = currentClaimPrice * wizardCommissionFractionNum / wizardCommissionFractionDen;
        uint winnings = currentClaimPrice - commission;
        
        currentMonarch.etherAddress.send(winnings);

        pastMonarchs.push(currentMonarch);
        
        currentMonarch = Monarch(
            msg.sender,
            name,
            currentClaimPrice * claimPriceAdjustNum / claimPriceAdjustDen,
            block.timestamp
        );
        
        currentClaimPrice = currentMonarch.claimPrice;
        
        if (excess > 0) {
            msg.sender.send(excess);
        }
        
        ThroneClaimed(msg.sender, name, currentClaimPrice);
    }
```