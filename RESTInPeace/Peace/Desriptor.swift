//
//  Desriptor.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/31.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation
import Alamofire

struct Descriptor {
    init(method: Alamofire.Method = .GET,
         encoding:Alamofire.ParameterEncoding = .URL ) {
        self.method = method
        self.encoding = encoding
    }
    
    var baseURL:NSURL?
    var method:Alamofire.Method
    var encoding:Alamofire.ParameterEncoding
    
    var headers:[String:String] = [:]
    
    var accept:String? {
        get {
            return headers["Accept"]
        }
        set {
            headers["Accept"] = newValue
        }
    }
    var authorization:String? {
        get {
            return headers["Authorization"]
        }
        set {
            headers["Authorization"] = newValue
        }
    }
    
}

extension Descriptor {
    func with(modify:(inout Descriptor) -> Void) -> Descriptor {
        var newDescriptor = self
        modify(&newDescriptor)
        return newDescriptor
    }
}
