```solidity
        // TODO:You need to complete this function
function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
    uint amount = bet.amount;
    uint modulo = bet.modulo;
    uint rollUnder = bet.rollUnder;
    address gambler = bet.gambler;

    require (amount != 0, "Bet should be in an 'active' state");

    bet.amount = 0;

    bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));

    uint dice = uint(entropy) % modulo;

    uint diceWinAmount;
    uint _jackpotFee;
    (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);

    uint diceWin = 0;
    uint jackpotWin = 0;

    if (modulo <= MAX_MASK_MODULO) {
        if ((2 ** dice) & bet.mask != 0) {
            diceWin = diceWinAmount;
        }
    } else {
        if (dice < rollUnder) {
            diceWin = diceWinAmount;
        }
    }

    lockedInBets -= uint128(diceWinAmount);

    if (amount >= MIN_JACKPOT_BET) {
        if (dice == modulo - 1) {
            jackpotWin = jackpotSize;
            jackpotSize = 0;
        }
    }

    sendFunds(gambler, diceWin + jackpotWin == 0 ? amount : amount + diceWin + jackpotWin, diceWin + amount);
}
```