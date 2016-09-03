//
//  StructWrapper.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/9/3.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import Foundation

//in some cases of Cocoa we need an `AnyObject`
//but actually have to pass a Struct which is only an `Any`.
//here is a wrapper.
class Wrapper<T> {
    let value:T
    init(_ value:T) {
        self.value = value
    }
}