[_token].closingTime,
            "Failed to buy token due to closing time is over."
        );

        uint256 commissionValue = msg.value.mul(
            crowdsales[_token].commission
        ).div(100);

        uint256 tokenBought = msg.value.sub(commissionValue).mul(
            crowdsales[_token].rate
        );

        require(
            ERC20(_token).transfer(msg.sender, tokenBought),
            "Failed to buy token due to transfer tokens failed."
        );

        address(_token).transfer(
            commissionValue
        );

        crowdsales[_token].raised = crowdsales[_token].raised.add(msg.value);

        emit TokenBought(msg.sender, _token, tokenBought);

        if (crowdsales[_token].raised == crowdsales[_token].cap) {
            crowdsales[_token].state = States.Closed;
            emit CrowdsaleClosed(msg.sender, _token);
        }
    }

    function <!TODO:You need to complete this function> 
        withdrawRaisedWei(
        address _token,
        uint256 _value
    )
        external
        onlyCrowdsaleOwner(_token)
        inState(_token, States.Closed)
    {
        require(
            _value <= crowdsales[_token].raised,
            "Failed to withdraw raised wei due to more than raised amount."
        );

        crowdsales[_token].raised = crowdsales[_token].raised.sub(_value);

        msg.sender.transfer(_value);

        emit RaisedWeiClaimed(msg.sender, _token, _value);
    }
}