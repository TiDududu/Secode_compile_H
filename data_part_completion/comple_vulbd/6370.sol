```solidity
function releaseToken(uint256 _round) public onlyOwner {
    require(_round >= 1 && _round <= 5);
    
    if (_round == 1 && now >= first_round_release_time) {
        validateReleasedToken(1);
    } else if (_round == 2 && now >= second_round_release_time) {
        validateReleasedToken(2);
    } else if (_round == 3 && now >= third_round_release_time) {
        validateReleasedToken(3);
    } else if (_round == 4 && now >= forth_round_release_time) {
        validateReleasedToken(4);
    } else if (_round == 5 && now >= fifth_round_release_time) {
        validateReleasedToken(5);
    } else {
        revert("Round has not been reached or invalid round");
    }
}
```