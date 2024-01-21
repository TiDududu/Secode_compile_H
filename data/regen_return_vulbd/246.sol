pragma solidity ^0.4.26;

contract DisputeSettlement {
    mapping(address => uint256) public balances;

    event AmountShift(address indexed juror, uint256 amount);
    event Log(string message, uint256 value);

    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
        require(_token == address(this));
        balances[_from] += _value;
    }

    function withdrawJuror() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0);
        balances[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    function withdrawSelect(address _juror) public {
        uint256 amount = balances[_juror];
        require(amount > 0);
        balances[_juror] = 0;
        _juror.transfer(amount);
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function withdrawAttacker() public {
        require(msg.sender == attacker);
        uint256 amount = address(this).balance;
        require(amount > 0);
        attacker.transfer(amount);
    }

    function settle(bool _outcome, address[] _jurors, uint256[] _votes) public {
        uint256 totalStake = 0;
        for (uint256 i = 0; i < _jurors.length; i++) {
            totalStake += balances[_jurors[i]];
        }
        require(totalStake > 0);

        uint256 totalShifted = 0;
        for (uint256 j = 0; j < _jurors.length; j++) {
            uint256 jurorStake = balances[_jurors[j]];
            uint256 jurorVote = _votes[j];
            if ((_outcome && jurorVote == 1) || (!_outcome && jurorVote == 0)) {
                uint256 amountShifted = jurorStake * totalStake / sub(totalStake, jurorStake);
                balances[_jurors[j]] = 0;
                _jurors[j].transfer(amountShifted);
                totalShifted += amountShifted;
                emit AmountShift(_jurors[j], amountShifted);
            }
        }
        emit Log("Total amount shifted", totalShifted);
    }
}