```
  function setTeams(uint _gameId, Teams _teamA, Teams _teamB) external onlyAdmin {
        require(_gameId > 0);
        require (!existingGames[_gameId].isValid);
        GameChanged(_gameId, existingGames[_gameId].gameDate, _teamA, _teamB, 0, 0, false, 0, 0);
    }
```