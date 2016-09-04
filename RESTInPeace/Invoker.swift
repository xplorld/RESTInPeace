//
//  Invoker.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/31.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation
import Alamofire

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
        if model.loading { return }
        model.loading = true
        
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
                
                model.loading = false
                
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
                
                model.finalized()
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


func loadImage(url:URLStringConvertible?, handler:(UIImage? -> Void)) {
    guard let url = url else { handler(nil); return }
    Alamofire.request(.GET, url).response {
        (_, _, data, _) in
        if let data = data,
            let image = Transformer<UIImage>.Image(data) {
            handler(image)
        } else {
            handler(nil)
        }
    }
}











