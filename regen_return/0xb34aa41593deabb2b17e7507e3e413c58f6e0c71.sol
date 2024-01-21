pragma solidity ^0.8.0;

contract PyramidScheme {
    mapping(address => uint) public balanceOf;
    mapping(address => uint) public dividendsOf;
    uint public totalSupply;
    uint public totalDividends;

    event Withdrawal(address indexed user, uint amount);

    function buyTokens() public payable {
        uint tokens = msg.value;
        balanceOf[msg.sender] += tokens;
        totalSupply += tokens;
    }

    function sellTokens(uint tokens) public {
        require(balanceOf[msg.sender] >= tokens, "Insufficient balance");
        
        uint etherAmount = tokens;
        balanceOf[msg.sender] -= tokens;
        totalSupply -= tokens;
        
        msg.sender.transfer(etherAmount);
    }

    function balanceOf(address _owner) public view returns (uint) {
        return balanceOf[_owner];
    }

    function withdraw() public {
        uint dividends = dividendsOf[msg.sender];
        dividendsOf[msg.sender] = 0;
        totalDividends -= dividends;

        payable(msg.sender).transfer(dividends);
        emit Withdrawal(msg.sender, dividends);
    }

    function reinvestDividends() public {
        uint dividends = dividendsOf[msg.sender];
        dividendsOf[msg.sender] = 0;
        balanceOf[msg.sender] += dividends;
        totalSupply += dividends;
    }
}