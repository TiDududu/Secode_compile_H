pragma solidity ^0.4.26;

contract FilmDocumentManagement {
    address public owner;
    
    struct Subtitle {
        string filmName;
        string contractType;
        string contractHash;
        uint signingDate;
        uint stripeTxNumber;
    }
    
    Subtitle[] public subtitles;
    mapping(string => uint[]) private isanSubtitles;
    
    event SubtitleCreated(string filmName, string contractType, string contractHash, uint signingDate, uint stripeTxNumber);
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }
    
    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
    
    function createSubtitle(string _filmName, string _contractType, string _contractHash, uint _signingDate, uint _stripeTxNumber) public {
        subtitles.push(Subtitle(_filmName, _contractType, _contractHash, _signingDate, _stripeTxNumber));
        uint id = subtitles.length - 1;
        isanSubtitles[_filmName].push(id);
        emit SubtitleCreated(_filmName, _contractType, _contractHash, _signingDate, _stripeTxNumber);
    }
    
    function getSubtitleArray(uint index) public view returns (string, string, string, uint, uint) {
        require(index < subtitles.length, "Invalid index");
        Subtitle storage subtitle = subtitles[index];
        return (subtitle.filmName, subtitle.contractType, subtitle.contractHash, subtitle.signingDate, subtitle.stripeTxNumber);
    }
    
    function getArrayLength(string _filmName) public view returns (uint) {
        return isanSubtitles[_filmName].length;
    }
    
    function getISANsubtitles(string _filmName) public view returns (uint[]) {
        return isanSubtitles[_filmName];
    }
    
    function getFilmName(uint index) public view returns (string) {
        require(index < subtitles.length, "Invalid index");
        return subtitles[index].filmName;
    }
    
    function getContractType(uint index) public view returns (string) {
        require(index < subtitles.length, "Invalid index");
        return subtitles[index].contractType;
    }
    
    function getContractHash(uint index) public view returns (string) {
        require(index < subtitles.length, "Invalid index");
        return subtitles[index].contractHash;
    }
    
    function getSigningDate(uint index) public view returns (uint) {
        require(index < subtitles.length, "Invalid index");
        return subtitles[index].signingDate;
    }
    
    function getStripeTxNumber(uint index) public view returns (uint) {
        require(index < subtitles.length, "Invalid index");
        return subtitles[index].stripeTxNumber;
    }
}