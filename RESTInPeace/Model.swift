//
//  Model.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/31.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation
import Swift
/*
 public protocol ModelType {
 //public get, internal set
 associatedtype ValueType
 associatedtype ModelHandler = (Self -> Void)
 associatedtype ResponseHandler = (Response<ValueType>) -> Void
 
 var value:ValueType? {get}
 var response:Response<ValueType>? {get}
 
 /*should be called by the lib only, aka `internal` */
 func succeed(response: Response<ValueType>)
 func failed(response: Response<ValueType>)
 init()
 }*/

public class Model<T> /* : ModelType */ {
    public typealias ValueType = T
    //public get, internal set
    public internal(set) var value:T?
    public internal(set) var response:Response<T>?
    
    public typealias ResponseHandler =  (Response<T>) -> Void
    
    internal var loader:(Model -> Void)!
    internal var onSuccessHandler:ResponseHandler?
    internal var onFailureHandler:ResponseHandler?
    internal var onFinalizeHandler:(Model -> Void)?
    
    internal var loading:Bool = false
    internal func succeed(response: Response<T>) {
        self.response = response
        self.value = response.value.getValue()
        onSuccessHandler?(response)
    }
    
    internal func failed(response: Response<T>) {
        self.response = response
        onFailureHandler?(response)
    }
    
    internal func finalized() {
        onFinalizeHandler?(self)
    }
    
//interface
    public func reload() {
        value = nil
        response = nil
        loader(self)
    }
    
    public func OnReload(handler: (Model -> Void)) -> Self {
        guard loader == nil else { fatalError("try to assign a once-assignable lambda twice")}
        loader = handler
        return self
    }
    
    //todo: or allow multiple onsuccess handler?
    public func OnSuccess(handler: ResponseHandler) -> Self {
        guard onSuccessHandler == nil else { fatalError("try to assign a once-assignable lambda twice")}
        
        onSuccessHandler = handler
        return self
    }
    
    public func OnFailure(handler: ResponseHandler) -> Self {
        guard onFailureHandler == nil else { fatalError("try to assign a once-assignable lambda twice")}
        onFailureHandler = handler
        return self
    }
    
    public func Finally(handler: (Model -> Void)) -> Self {
        guard onFinalizeHandler == nil else { fatalError("try to assign a once-assignable lambda twice")}
        onFinalizeHandler = handler
        return self
    }

}


