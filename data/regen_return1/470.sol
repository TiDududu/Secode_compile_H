pragma solidity ^0.4.26;

interface ERC20 {
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external view returns (uint8);
}

contract MultiTokenInterface {
    ERC20[] public allTokens;
    uint8[] public allDecimals;
    uint256[] public allBalances;
    uint256[] public allWeights;

    function tokensCount() public view returns (uint256) {
        return allTokens.length;
    }

    function tokens(uint256 index) public view returns (ERC20) {
        require(index < allTokens.length, "Invalid index");
        return allTokens[index];
    }

    function allTokens() public view returns (ERC20[]) {
        return allTokens;
    }

    function allDecimals() public view returns (uint8[]) {
        return allDecimals;
    }

    function allBalances() public view returns (uint256[]) {
        return allBalances;
    }

    function allWeights() public view returns (uint256[]) {
        return allWeights;
    }

    function allTokensDecimalsBalances() public view returns (ERC20[], uint8[], uint256[]) {
        return (allTokens, allDecimals, allBalances);
    }

    function allTokensDecimalsBalancesWeights() public view returns (ERC20[], uint8[], uint256[], uint256[]) {
        return (allTokens, allDecimals, allBalances, allWeights);
    }

    function bundleFirstTokens(address beneficiary, uint256[] tokenAmounts) public {
        require(tokenAmounts.length == allTokens.length, "Invalid token amounts length");
        for (uint256 i = 0; i < allTokens.length; i++) {
            require(tokenAmounts[i] > 0, "Invalid token amount");
            require(allTokens[i].transferFrom(msg.sender, beneficiary, tokenAmounts[i]), "Transfer failed");
        }
    }

    function bundle(address beneficiary, uint256 amount) public {
        require(allTokens.length > 0, "No tokens available");
        uint256 totalWeight = 0;
        for (uint256 i = 0; i < allTokens.length; i++) {
            totalWeight += allWeights[i];
        }
        for (uint256 j = 0; j < allTokens.length; j++) {
            uint256 tokenAmount = amount * allWeights[j] / totalWeight;
            require(allTokens[j].transferFrom(msg.sender, beneficiary, tokenAmount), "Transfer failed");
        }
    }

    function unbundle(address beneficiary, uint256 amount) public {
        require(allTokens.length > 0, "No tokens available");
        for (uint256 i = 0; i < allTokens.length; i++) {
            uint256 tokenAmount = amount * allBalances[i] / allBalances[i];
            require(allTokens[i].transfer(beneficiary, tokenAmount), "Transfer failed");
        }
    }

    function unbundleSome(address beneficiary, uint256[] tokenAmounts) public {
        require(tokenAmounts.length == allTokens.length, "Invalid token amounts length");
        for (uint256 i = 0; i < allTokens.length; i++) {
            require(tokenAmounts[i] > 0, "Invalid token amount");
            require(allTokens[i].transfer(beneficiary, tokenAmounts[i]), "Transfer failed");
        }
    }

    function getReturn(uint256 amount) public view returns (uint256) {
        require(allTokens.length > 0, "No tokens available");
        uint256 totalWeight = 0;
        for (uint256 i = 0; i < allTokens.length; i++) {
            totalWeight += allWeights[i];
        }
        uint256 returnAmount = 0;
        for (uint256 j = 0; j < allTokens.length; j++) {
            returnAmount += amount * allBalances[j] / totalWeight;
        }
        return returnAmount;
    }

    function change(uint256 fromIndex, uint256 toIndex, uint256 minReturn) public {
        require(fromIndex < allTokens.length && toIndex < allTokens.length, "Invalid token index");
        require(fromIndex != toIndex, "Cannot change to the same token");
        uint256 fromBalance = allBalances[fromIndex];
        require(fromBalance > 0, "Insufficient balance");
        uint256 toBalance = allBalances[toIndex];
        uint256 amount = fromBalance * allWeights[toIndex] / allWeights[fromIndex];
        require(amount >= minReturn, "Minimum return not met");
        require(allTokens[fromIndex].transfer(msg.sender, fromBalance), "Transfer failed");
        require(allTokens[toIndex].transferFrom(msg.sender, fromBalance), "Transfer failed");
    }
}