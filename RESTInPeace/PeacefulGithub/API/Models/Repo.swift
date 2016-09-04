//
//  Repo.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/9/4.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import SwiftyJSON

struct Repo : JSONConvertible {
    var id:Int?
    var name:String?
    var description:String?
    var forks_count:Int?
    var stargazers_count:Int?
    var owner:User?
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string
        description = json["description"].string
        forks_count = json["forks_count"].int
        stargazers_count = json["stargazers_count"].int
        owner <- json["owner"]
    }
}