//
//  JSONConvertible.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//
import SwiftyJSON
import Swift

protocol JSONConvertible {
    static func fromJSON(json: JSON) -> Self
}

extension JSONConvertible {
    static func arrayFromJSON(json: JSON) -> [Self] {
        return json.arrayValue.map { Self.fromJSON($0) }
    }
}

extension JSON {
    func toType<T:JSONConvertible>() -> T {
        return T.fromJSON(self)
    }
    func toArray<T:JSONConvertible>() -> [T] {
        return T.arrayFromJSON(self)
    }
}

infix operator <- {
    associativity none
    precedence 90
    assignment
}

func <- <T:JSONConvertible>(inout lhs:T?, rhs:JSON) -> Void {
    lhs = T.fromJSON(rhs)
}
