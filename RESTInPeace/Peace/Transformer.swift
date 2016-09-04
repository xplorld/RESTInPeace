//
//  Transformer.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import SwiftyJSON
import UIKit



struct Transformer<T> {
    typealias TransformerType = (NSData -> T?)
}

extension Transformer where T : JSONConvertible {
    static var JSON : TransformerType {
        get {
            return { return SwiftyJSON.JSON(data: $0).toType() }
        }
    }
}

extension Transformer where T : CollectionType, T.Generator.Element : JSONConvertible {
    static var JSON : (NSData -> [T.Generator.Element] ) {
        get {
            return { return SwiftyJSON.JSON(data: $0).toArray() }
        }
    }
}

extension Transformer where T : UIImage {
    static var Image : TransformerType {
        get {
            return { return T(data: $0) }
        }
    }
}
