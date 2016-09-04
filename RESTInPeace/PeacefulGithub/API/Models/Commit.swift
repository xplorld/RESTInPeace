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
    var date:NSDate?
    
    static func fromJSON(json: JSON) -> Commit? {
        var commit = Commit()
        commit.sha = json["sha"].string
        commit.message = json["commit"]["message"].string
        commit.commiter <- json["commitor"]
        commit.author <- json["author"]
        commit.date <- json["commit"]["author"]["date"]
        return commit
    }
}

