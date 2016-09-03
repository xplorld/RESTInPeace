//
//  LinkHeader.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/9/3.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation

extension NSRange {
    func rangeForString(str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        return str.startIndex.advancedBy(location) ..< str.startIndex.advancedBy(location + length)
    }
}

extension String {
    
    func firstMatchInString(text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: self, options: NSRegularExpressionOptions.CaseInsensitive)
            if let match = regex.firstMatchInString(text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
                return (1..<match.numberOfRanges)
                    .flatMap { match.rangeAtIndex($0).rangeForString(text) }
                    .map { text.substringWithRange($0) }
            }
        } catch {
            // regex was bad!
        }
        return []
    }
    
}

public struct LinkHeader {
    private let dict:[String:String]!
    
    subscript(rel: String) -> String? {
        return dict[rel]
    }
    
    public init(value: String) {
        dict = [:]
        let pairs = value.componentsSeparatedByString(",").map {
            "<(.*)>; rel=\"(.*)\"".firstMatchInString($0)
        }
        for pair in pairs {
            dict[pair[1]] = pair[0]
        }
    }
    public func toString() -> String {
        return dict
            .map { rel, url in
                "<\(url)>; rel=\"\(rel)\""
            }
            .joinWithSeparator(",")
    }
}