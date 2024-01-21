```solidity
function addMembers(address[] _member, uint256[] _tokens) onlyOwner public {
    require(_member.length == _tokens.length);
    for (uint256 i = 0; i < _member.length; i++) {
        team.push(Member(_member[i], _tokens[i]));
    }
}
```