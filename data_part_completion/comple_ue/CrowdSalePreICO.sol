```solidity
    function setPricing() onlyController{
        uint factor = 10 ** decimals;
        priceList.push(PriceTier(uint(safeDiv(1 ether, 400 * factor)),0,5000 ether));
        priceList.push(PriceTier(uint(safeDiv(1 ether, 400 * factor)),0,1 ether));
        numTiers = 2;
    }
```