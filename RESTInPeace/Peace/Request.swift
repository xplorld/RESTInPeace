//
//  Request.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import UIKit

class Request<T> {
    typealias SuccessHandler =  (Response<T>) -> Void
    typealias FailureHandler = (Response<ErrorType>) -> Void
    internal var onSuccess:SuccessHandler?
    internal var onFailure:FailureHandler?
    
    internal func succeed(response: Response<T>) {
        onSuccess?(response)
        onSuccess = nil
    }
    
    internal func failed(response: Response<ErrorType>) {
        onFailure?(response)
        onFailure = nil
    }
    
    func OnSuccess(handler: SuccessHandler) -> Self {
        onSuccess = handler
        return self
    }
    
    func OnFailure(handler: FailureHandler) -> Self {
        onFailure = handler
        return self
    }
}
