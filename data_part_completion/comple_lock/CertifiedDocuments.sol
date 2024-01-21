```solidity
function createSubtitle(
    bytes32 ISANfilm_,
    bytes32 ISANsubtitles_,
    string memory filmName_,
    string memory contractType_,
    string memory contractHash_,
    string memory signingDate_,    
    uint256 stripeTxNumber_
)
    payable
public  
{
    project[ISANsubtitles_] = subtitles(ISANfilm_, filmName_, contractType_, contractHash_, signingDate_, stripeTxNumber_);
    ISANSubArray[ISANfilm_].push(ISANsubtitles_);
    ArrayLength[ISANfilm_] = ISANSubArray[ISANfilm_].length;
    ISANFilmArray.push(ISANfilm_);
    emit SubtitleCreated(ISANsubtitles_);
}
```