//
//  Invoker.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/31.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation
import Alamofire

protocol Invoker {
    associatedtype ObjectType
    var descriptor: Descriptor { get }
}

extension Invoker {
    func request<T>(URL: NSURL,
                 parameters:[String:AnyObject]? = nil,
                 transformer: NSData -> T?) -> Model<T>
    {
        let model = Model<T>()
        let descriptor = self.descriptor
        model.load = { model in
            Alamofire
                .request(
                    descriptor.method,
                    URL,
                    parameters: parameters,
                    encoding: descriptor.encoding,
                    headers: descriptor.headers)
                .response {
                    request, response, data, error in
                    if (error != nil || data == nil /* || !validate(resp)*/) {
                        model.failed(
                            Response(
                                request: request,
                                response: response,
                                value: error))
                    } else {
                        let object = transformer(data!)
                        model.succeed(
                            Response(
                                request: request,
                                response: response,
                                value: object))
                    }
            }
        }
        return model
    }
}
