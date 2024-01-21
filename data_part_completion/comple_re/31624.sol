```solidity
function buy(
        IMultiToken _mtkn,
        uint256 _minimumReturn,
        ERC20 _throughToken,
        address[] _exchanges,
        bytes _datas,
        uint[] _datasIndexes,
        uint256[] _values
    )
        public
        payable
    {
        require(_exchanges.length == _datasIndexes.length && _exchanges.length == _values.length);
        for (uint i = 0; i < _exchanges.length; i++) {
            require(_exchanges[i] != address(0));
            require(_datasIndexes[i] > 0 && _datasIndexes[i] < _datas.length);

            bytes memory data = new bytes(_datasIndexes[i]);
            for (uint j = 0; j < _datasIndexes[i]; j++) {
                data[j] = _datas[j];
            }
            require(_mtkn.change(ERC20(_throughToken), _mtkn.tokens(i), _values[i], _minimumReturn) >= _minimumReturn);
            require(_mtkn.tokens(i).approve(_exchanges[i], _values[i]));
            require(_mtkn.tokens(i).transferFrom(msg.sender, this, _values[i]));
            require(_mtkn.tokens(i).transfer(_exchanges[i], _values[i]));
            require(_mtkn.tokens(i).transfer(msg.sender, _mtkn.getReturn(_mtkn.tokens(i), ERC20(_throughToken), _values[i])));
        }
    }
```