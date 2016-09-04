//
//  Commit.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/9/4.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import SwiftyJSON

struct Commit : JSONConvertible {
    var sha:String?
    var commiter:User?
    var author:User?
    var message:String?
    
    init(json: JSON) {
        sha = json["sha"].string
        message = json["commit"]["message"].string
        commiter <- json["commitor"]
        author <- json["author"]
    }
}

