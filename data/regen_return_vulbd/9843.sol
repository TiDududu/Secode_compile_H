pragma solidity ^0.4.26;

contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
}

library DateTime {
    struct MyDateTime {
        uint16 year;
        uint8 month;
        uint8 day;
    }
    
    function isLeapYear(uint16 year) internal pure returns (bool) {
        if (year % 4 != 0) {
            return false;
        }
        if (year % 100 != 0) {
            return true;
        }
        if (year % 400 != 0) {
            return false;
        }
        return true;
    }
    
    function leapYearsBefore(uint16 year) internal pure returns (uint16) {
        year -= 1;
        return uint16(year / 4 - year / 100 + year / 400);
    }
    
    function getDaysInMonth(uint16 year, uint8 month) internal pure returns (uint8) {
        if (month == 2) {
            return isLeapYear(year) ? 29 : 28;
        }
        if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        }
        return 31;
    }
    
    function parseTimestamp(uint256 timestamp) internal pure returns (MyDateTime memory) {
        uint256 secondsAccountedFor = 0;
        uint16 year;
        uint8 month;
        uint8 day;
        
        uint256 secondsInYear;
        uint256 secondsInMonth;
        
        year = getYear(timestamp);
        secondsInYear = isLeapYear(uint16(year)) ? 31622400 : 31536000;
        
        while (true) {
            if (isLeapYear(uint16(year))) {
                secondsInMonth = secondsAccountedFor + 2505600;
            } else {
                secondsInMonth = secondsAccountedFor + 2592000;
            }
            if (secondsInMonth > secondsInYear) {
                secondsInMonth -= secondsInYear;
                month++;
                if (secondsInMonth > secondsInYear) {
                    secondsInMonth -= secondsInYear;
                    month++;
                }
            } else {
                month++;
            }
            if (secondsInMonth < getDaysInMonth(year, month) * 86400) {
                day = uint8(secondsInMonth / 86400) + 1;
                break;
            }
            secondsAccountedFor += getDaysInMonth(year, month) * 86400;
        }
        return MyDateTime(year, month, day);
    }
    
    function getYear(uint256 timestamp) internal pure returns (uint16) {
        uint256 secondsAccountedFor = 0;
        uint16 year;
        uint256 secondsInYear;
        
        year = uint16(1970 + timestamp / 31536000);
        secondsInYear = isLeapYear(year) ? 31622400 : 31536000;
        while (secondsAccountedFor < timestamp) {
            if (isLeapYear(year)) {
                secondsAccountedFor += 31622400;
            } else {
                secondsAccountedFor += 31536000;
            }
            year += 1;
        }
        return year - 1;
    }
}