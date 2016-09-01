//
//  Peace.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation

public struct Response<T> {
    public let request: NSURLRequest?
    public let response : NSHTTPURLResponse?
    public let value: T?
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
