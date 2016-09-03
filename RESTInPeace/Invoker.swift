//
//  Invoker.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/31.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation
import Alamofire
import Swift

public protocol Invoker {
    associatedtype ObjectType
    var descriptor: Descriptor { get }
}

extension Invoker {
    public func request<T>(
        model:Model<T>,
        URL: URLStringConvertible,
        parameters:[String:AnyObject]? = nil,
        transformer: NSData -> T?)
    {
        let descriptor = self.descriptor
        
        Alamofire
            .request(
                descriptor.method,
                URL,
                parameters: parameters,
                encoding: descriptor.encoding,
                headers: descriptor.headers)
            .validate(statusCode: 200..<400)
            .response {
                request, response, data, error in
                if (error != nil || data == nil /* || !validate(resp)*/) {
                    model.failed(
                        Response<T>(
                            request: request,
                            response: response,
                            value: ValueOrError.Error(error)))
                } else {
                    let object = transformer(data!)
                    model.succeed(
                        Response(
                            request: request,
                            response: response,
                            value: ValueOrError.Value(object)))
                }
                
        }
    }
    public func requestJSONArray<T:JSONConvertible>(
        model:Model<[T]>,
        URL: URLStringConvertible,
        parameters:[String:AnyObject]? = nil)
    {
        let transformer = Transformer<[T]>.JSON
        return request(model, URL: URL, parameters: parameters, transformer: transformer)
    }
    public func requestJSON<T:JSONConvertible>(
        model:Model<T>,
        URL: URLStringConvertible,
        parameters:[String:AnyObject]? = nil)
    {
        let transformer = Transformer<T>.JSON
        return request(model, URL: URL, parameters: parameters, transformer: transformer)
    }
    
}
