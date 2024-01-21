pragma solidity ^0.4.26;

contract SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
}

contract Owned {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ERC918Interface {
    function getAdjustmentInterval() public view returns (uint);
    function getChallengeNumber() public view returns (bytes32);
    function getMiningDifficulty() public view returns (uint);
    function getMiningTarget() public view returns (uint);
    function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
}

contract ZeroGoldPOWMining is ERC918Interface, Owned, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    uint public latestDifficultyPeriodStarted;
    uint public epochCount;
    uint public _BLOCKS_PER_READJUSTMENT = 1024;

    bytes32 public challengeNumber;
    uint public miningTarget;

    bytes32 public challengeDigest;
    uint public nonce;
    uint public difficulty;
    uint public maxNonce;

    uint public rewardEra;
    uint public maxSupplyForEra;
    uint public lastRewardTo;
    uint public lastRewardAmount;
    uint public lastRewardEthBlockNumber;
    bool locked = false;

    constructor() public {
        name = "ZeroGold";
        symbol = "ZG";
        decimals = 18;
        _totalSupply = 1000000 * 10**uint(decimals);
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
        latestDifficultyPeriodStarted = block.number;
        _startNewMiningEpoch();
    }

    function merge(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
        bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
        require(digest == challenge_digest);
        require(uint256(digest) < miningTarget);
        uint reward_amount = getMiningReward();
        balances[msg.sender] = add(balances[msg.sender], reward_amount);
        _totalSupply = add(_totalSupply, reward_amount);
        challengeNumber = keccak256(abi.encodePacked(challengeNumber, nonce, digest, blockhash(block.number)));
        _startNewMiningEpoch();
        return true;
    }

    function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
        bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
        require(digest == challenge_digest);
        require(uint256(digest) < miningTarget);
        uint reward_amount = getMiningReward();
        balances[msg.sender] = add(balances[msg.sender], reward_amount);
        _totalSupply = add(_totalSupply, reward_amount);
        challengeNumber = keccak256(abi.encodePacked(challengeNumber, nonce, digest, blockhash(block.number)));
        _startNewMiningEpoch();
        return true;
    }

    function getMiningReward() public view returns (uint) {
        return (50 * 10**uint(decimals)) / (2**rewardEra);
    }

    function _startNewMiningEpoch() internal {
        if (epochCount % _BLOCKS_PER_READJUSTMENT == 0) {
            _reAdjustDifficulty();
        }
        if (block.number - latestDifficultyPeriodStarted > 255) {
            _reAdjustDifficulty();
        }
        challengeNumber = blockhash(block.number - 1);
        epochCount = add(epochCount, 1);
    }

    function _reAdjustDifficulty() internal {
        uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
        uint timeTaken = uint(block.timestamp - lastRewardEthBlockNumber);
        uint targetEthBlocksPerDiffPeriod = _BLOCKS_PER_READJUSTMENT;
        if (timeTaken < _BLOCKS_PER_READJUSTMENT) {
            timeTaken = _BLOCKS_PER_READJUSTMENT;
        }
        if (timeTaken > _BLOCKS_PER_READJUSTMENT * 2) {
            timeTaken = _BLOCKS_PER_READJUSTMENT * 2;
        }
        uint rewardEthBlocks = (ethBlocksSinceLastDifficultyPeriod * targetEthBlocksPerDiffPeriod) / timeTaken;
        if (rewardEthBlocks < 1) {
            rewardEthBlocks = 1;
        }
        if (rewardEthBlocks > 4) {
            rewardEthBlocks = 4;
        }
        miningTarget = miningTarget * rewardEthBlocks / targetEthBlocksPerDiffPeriod;
        latestDifficultyPeriodStarted = block.number;
        lastRewardEthBlockNumber = block.timestamp;
    }
}