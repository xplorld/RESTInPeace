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
    //public get, private set
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
    //public get, private set
    public private(set) var value:T?
    public private(set) var response:Response<T>?
    
    public typealias ModelHandler = (Model -> Void)
    public typealias ResponseHandler =  (Response<T>) -> Void
    
    private var loader:ModelHandler!
    private var onSuccessHandler:ResponseHandler?
    private var onFailureHandler:ResponseHandler?
    
    internal func succeed(response: Response<T>) {
        self.response = response
        self.value = response.value.getValue()
        onSuccessHandler?(response)
    }
    
    internal func failed(response: Response<T>) {
        self.response = response
        onFailureHandler?(response)
    }
}

//interface
extension Model {
    
    func reload() {
        value = nil
        response = nil
        loader(self)
    }
    
    func OnReload(handler: ModelHandler) -> Self {
        guard loader == nil else { fatalError("try to assign a once-assignable lambda twice")}
            loader = handler
        return self
    }
    
    //todo: or allow multiple onsuccess handler?
    func OnSuccess(handler: ResponseHandler) -> Self {
        guard onSuccessHandler == nil else { fatalError("try to assign a once-assignable lambda twice")}
        
            onSuccessHandler = handler
        return self
    }
    
    func OnFailure(handler: ResponseHandler) -> Self {
        guard onFailureHandler == nil else { fatalError("try to assign a once-assignable lambda twice")}
            onFailureHandler = handler
        return self
    }
}



public class PaginatedSequenceModel<T> : Model<[T]> {
    
    private var nextPageLoader : ModelHandler!
    
    override public func succeed(response: Response<[T]>) {
        self.response = response
        guard let newValues = response.value.getValue() else { return }
        if self.value == nil {
            self.value = newValues
            return
        }
        self.value!.appendContentsOf(newValues)
    }
}

extension PaginatedSequenceModel {
    
    func loadNextPage() {
        if response != nil && value != nil {
            nextPageLoader(self)
        } else {
            reload()
        }
    }
    func OnReloadNextPage(handler: ModelHandler) -> Self {
        guard nextPageLoader == nil else { fatalError("try to assign a once-assignable lambda twice")}
        nextPageLoader = handler
        return self
    }
    
}