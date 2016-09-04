//
//  User.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/9/4.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import SwiftyJSON

struct User : JSONConvertible {
    var id:Int?
    var url:String?
    var login:String?
    var avatar_url:String?
    
    init(json: JSON) {
        id = json["id"].int
        url = json["url"].string
        login = json["login"].string
        avatar_url = json["avatar_url"].string
    }
}
