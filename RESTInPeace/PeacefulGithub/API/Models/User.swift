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
    
    static func fromJSON(json: JSON) -> User? {
        var user = User()
        user.id = json["id"].int
        user.url = json["url"].string
        user.login = json["login"].string
        user.avatar_url = json["avatar_url"].string
        return user
    }
}
