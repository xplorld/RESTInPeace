//
//  PaginatedSequenceModel.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/9/3.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation
import UIKit

public class PaginatedSequenceModel<T> : Model<[T]> {
    
    internal var nextPageLoader : (PaginatedSequenceModel -> Void)!
    public   var noMoreToLoad:Bool = false
    
    override internal func succeed(response: Response<[T]>) {
        self.response = response
        
        let newValues = response.value.getValue()
        //vn -> nothing
        //vv -> append
        //nv -> set
        //nn -> set
        if self.value == nil {
            self.value = newValues
        } else {
            if newValues != nil {
                self.value!.appendContentsOf(newValues!)
            } //else do nothing
        }
        onSuccessHandler?(response)
    }
    override public func reload() {
        noMoreToLoad = false
        super.reload()
    }
}

extension PaginatedSequenceModel {
    
    func loadNextPage() {
        if noMoreToLoad { return }
        
        if response != nil && value != nil {
            nextPageLoader(self)
        } else {
            reload()
        }
    }
    func OnReloadNextPage(handler: (PaginatedSequenceModel -> Void)) -> Self {
        guard nextPageLoader == nil else { fatalError("try to assign a once-assignable lambda twice")}
        nextPageLoader = handler
        return self
    }
    
}
