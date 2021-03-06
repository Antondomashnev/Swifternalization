//
//  Regex.swift
//  Swifternalization
//
//  Created by Tomasz Szulc on 27/06/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

/**
Class uses NSRegularExpression internally and simplifies its usability.
*/
final class Regex {
    
    /**
    Return match in a string. Optionally with index of capturing group
    
    :param: str A string that will be matched.
    :param: pattern A regex pattern.
    :returns: `String` that matches pattern or nil.
    */
    class func matchInString(str: String, pattern: String, capturingGroupIdx: Int?) -> String? {
        var resultString: String?
        
        let range = NSMakeRange(0, count(str))
        regexp(pattern)?.enumerateMatchesInString(str, options: nil, range: range, usingBlock: { result, flags, stop in
            if let result = result {
                if let capturingGroupIdx = capturingGroupIdx where result.numberOfRanges > capturingGroupIdx {
                    resultString = self.substring(str, range: result.rangeAtIndex(capturingGroupIdx))
                } else {
                    resultString = self.substring(str, range: result.range)
                }
            }
        })
        
        return resultString
    }
    
    
    /**
    Return first match in a string.
    
    :param: str A string that will be matched.
    :param: pattern A regexp pattern.
    :returns: `String` that matches pattern or nil.
    */
    class func firstMatchInString(str: String, pattern: String) -> String? {
        if let result = regexp(pattern)?.firstMatchInString(str, options: .ReportCompletion, range: NSMakeRange(0, count(str))) {
            return substring(str, range: result.range)
        }
        return nil
    }
    
    /**
    Return all matches in a string.
    
    :param: str A string that will be matched.
    :param: pattern A regexp pattern.
    :returns: Array of `Strings`s. If nothing found empty array is returned.
    */
    class func matchesInString(str: String, pattern: String) -> [String] {
        var matches = [String]()
        if let results = regexp(pattern)?.matchesInString(str, options: .ReportCompletion, range: NSMakeRange(0, count(str))) as? [NSTextCheckingResult] {
            for result in results {
                matches.append(substring(str, range: result.range))
            }
        }
        
        return matches
    }
    
    /**
    Returns new `NSRegularExpression` object.
    
    :param: pattern A regexp pattern.
    :returns: `NSRegularExpression` object or nil if it cannot be created.
    */
    private class func regexp(pattern: String) -> NSRegularExpression? {
        var error: NSError? = nil
        var regexp = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)
        if error != nil {
            println(error!)
        }
        return regexp
    }
    
    /**
    Method that substring string with passed range.
    
    :param: str A string that is source of substraction.
    :param: range A range that tells which part of `str` will be substracted.
    :returns: A string contained in `range`.
    */
    private class func substring(str: String, range: NSRange) -> String {
        let startRange = advance(str.startIndex, range.location)
        let endRange = advance(startRange, range.length)
        
        return str.substringWithRange(Range(start: startRange, end: endRange))
    }
}