pragma solidity ^0.4.26;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

interface P3DTakeout {
    function buyTokens() external payable;
}

contract Betting {
    using SafeMath for uint256;

    address public owner;
    address public P3DContract_;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    modifier duringBetting() {
        require(chronus_info.betting_start < now && now < chronus_info.race_start, "Function can only be called during betting period");
        _;
    }

    modifier beforeBetting() {
        require(now < chronus_info.betting_start, "Function can only be called before betting period");
        _;
    }

    modifier afterRace() {
        require(now > chronus_info.race_end, "Function can only be called after the race has ended");
        _;
    }

    struct chronus_info {
        uint256 betting_start;
        uint256 race_start;
        uint256 race_end;
    }

    struct horses_info {
        uint256 BTC_delta;
        uint256 ETH_delta;
        uint256 LTC_delta;
    }

    struct bet_info {
        address bettor;
        uint256 amount;
        uint8 horse;
    }

    struct coin_info {
        uint256 pre_race_price;
        uint256 post_race_price;
        uint256 total;
        uint256 count;
        bool price_check;
    }

    struct voter_info {
        uint256 total_bets;
        bool reward_status;
    }

    mapping(uint8 => coin_info) public coinIndex;
    mapping(address => voter_info) public voterIndex;
    mapping(uint8 => bool) public winner_horse;

    event Deposit(address indexed _bettor, uint256 _amount, uint8 _horse);
    event Withdraw(address indexed _bettor, uint256 _amount);
    event PriceCallback(uint8 _coin, uint256 _pre_race_price, uint256 _post_race_price);
    event RefundEnabled(string _reason);

    constructor(address _P3DContract) public {
        owner = msg.sender;
        P3DContract_ = _P3DContract;
    }

    function changeOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function priceCallback(uint8 coin, uint256 preRacePrice, uint256 postRacePrice) public onlyOwner {
        coinIndex[coin].pre_race_price = preRacePrice;
        coinIndex[coin].post_race_price = postRacePrice;
        coinIndex[coin].price_check = true;
        emit PriceCallback(coin, preRacePrice, postRacePrice);
    }
}