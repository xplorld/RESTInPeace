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
    
    static func fromJSON(json: JSON) -> Repo? {
        var repo = Repo()
        repo.id = json["id"].int
        repo.name = json["name"].string
        repo.description = json["description"].string
        repo.forks_count = json["forks_count"].int
        repo.stargazers_count = json["stargazers_count"].int
        repo.owner <- json["owner"]
        return repo
    }
}