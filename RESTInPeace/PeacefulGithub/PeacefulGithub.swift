//
//  PeacefulGithub.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import UIKit
import SwiftyJSON

///Models
struct Owner : JSONConvertible {
    var id:Int?
    var url:String?
    
    static func fromJSON(json: JSON) -> Owner {
        var owner = Owner()
        owner.id = json["id"].int
        owner.url = json["url"].string
        return owner
    }
}

struct Repo : JSONConvertible {
    var id:Int?
    var name:String?
    var owner:Owner?
    static func fromJSON(json: JSON) -> Repo {
        var repo = Repo()
        repo.id = json["id"].int
        repo.name = json["name"].string
        repo.owner <- json["owner"]
        return repo
    }
}


///Descriptor
var githubDescriptor:Descriptor = Descriptor().with {
    $0.baseURL = NSURL(string: "https://api.github.com/")
    $0.accept = "application/vnd.github.v3+json"
    $0.authorization = "token f8ca64a01866698c56cf6853f9bac5a24efe283f"
}

///Invoker
struct GithubInvoker: Invoker {
    typealias ObjectType = Repo
    var descriptor: Descriptor = githubDescriptor
    func getURL(username:String) -> NSURL {
        return NSURL(string: "users/\(username)/repos", relativeToURL: descriptor.baseURL)!
    }
    
    func repo(username:String) -> Request<[Repo]> {
        return request(getURL(username),parameters: nil,transformer: Transformer.JSONArray())
    }
    
}
