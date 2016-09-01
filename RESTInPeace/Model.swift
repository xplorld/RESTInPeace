//
//  Model.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/31.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation

public class Model<T> {
    var value:T?
    
    var load:(Model<T> -> Void)!
    func reload() {
        value = nil
        load(self)
    }
    
    
    typealias SuccessHandler =  (Response<T>) -> Void
    typealias FailureHandler = (Response<ErrorType>) -> Void
    private var onSuccessHandler:SuccessHandler?
    private var onFailureHandler:FailureHandler?
    
    internal func succeed(response: Response<T>) {
        value = response.value
        onSuccessHandler?(response)
    }
    
    internal func failed(response: Response<ErrorType>) {
        onFailureHandler?(response)
        onFailureHandler = nil
    }
    
    func OnSuccess(handler: SuccessHandler) -> Self {
        onSuccessHandler = handler
        return self
    }
    
    func OnFailure(handler: FailureHandler) -> Self {
        onFailureHandler = handler
        return self
    }
}