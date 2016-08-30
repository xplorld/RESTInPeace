//
//  Peace.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Response<T> {
    let request: NSURLRequest?
    let response : NSHTTPURLResponse?
    let object: T?
}

//two classes
//invoker:      associatedtype T, request parameters
//descriptor:   URL, method, etc

//invokers are structs conforming certain protocols
//invokers construct URL, make parameter dicts, do dynamic things
//invoker call Peace.request with descriptor as params

//descriptor have a hierarchy
//descriptor provide relatively 'static' things, method, accepting, auth
//descriptor not exposed to final caller i.e. controllers

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

protocol Invoker {
    associatedtype ObjectType
    var descriptor: Descriptor { get }
}

extension Invoker {
    func request<T>(URL: NSURL,
                 parameters:[String:AnyObject]? = nil,
                 transformer: NSData -> T?
                 ) -> Request<T>
    {
        let request = Request<T>()
        Alamofire.request(
                descriptor.method,
                URL,
                parameters: parameters,
                encoding: descriptor.encoding,
                headers: descriptor.headers)
            .response {
                req, resp, data, error in
                if (error != nil || data == nil /* || !validate(resp)*/) {
                request.failed(Response(
                    request: req,
                    response: resp,
                    object: error))
                } else {
                    let object = transformer(data!)
                    request.succeed(
                        Response(
                            request: req,
                            response: resp,
                            object: object)
                    )
                }
            }
        return request
    }
}
