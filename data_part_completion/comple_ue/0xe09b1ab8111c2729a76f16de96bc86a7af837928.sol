```solidity
t;

    emit Refund(ticketID, ethToTransfer, requester);
    }

    function sendFunds(address recipient, uint amount)
    internal 
    returns (bool) 
    {
        if (address(this).balance >= amount) {
            recipient.transfer(amount);
            emit Payment(recipient, amount);
            return true;
        } else {
            emit FailedPayment(recipient, amount);
            return false;
        }
    }
}
```