//
//  JSONConvertible.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//
import SwiftyJSON
import Swift
import DateTools

public protocol JSONConvertible {
    static func fromJSON(json: JSON) -> Self?
}

public extension JSON {
    func toType<T: JSONConvertible>() -> T? {
        return T.fromJSON(self)
    }
    
    func toArray<T: JSONConvertible>() -> [T] {
        return self.arrayValue.flatMap { $0.toType() }
    }
}

extension NSDate : JSONConvertible {
    public static func fromJSON(json: JSON) -> Self? {
        return self.init(string: json.stringValue, formatString: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
}

/*

// For the time being, this code snippet would produce error:
// Extension of type 'Array' with constraints cannot have an inheritance clause
// If someday Swift do accept it, we would be able to eliminate all discriminations for Array in JSONConvertible's.
 
extension Array : JSONConvertible where Element : JSONConvertible {
    static func fromJSON(json: JSON) -> Array? {
        return json.arrayValue.flatMap { Element.fromJSON($0) }
    }
}
*/

infix operator <- {
    associativity none
    precedence 90
    assignment
}

func <- <T:JSONConvertible>(inout lhs:T?, rhs:JSON) -> Void {
    lhs = rhs.toType()
}

func <- <T:JSONConvertible>(inout lhs:T!, rhs:JSON) -> Void {
    lhs = rhs.toType()
}
