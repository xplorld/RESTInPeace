//
//  Transformer.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import SwiftyJSON
import UIKit


struct Transformer {
   static func JSON<T:JSONConvertible>() -> (NSData -> T?) {
        return {
            T.fromJSON(SwiftyJSON.JSON(data: $0))
        }
    }
    
   static func JSONArray<T:JSONConvertible>() -> (NSData -> [T]?) {
        return {
            T.arrayFromJSON(SwiftyJSON.JSON(data: $0))
        }
    }
    static func Image() -> (NSData -> UIImage?) {
        return { UIImage(data: $0) }
    }
}
