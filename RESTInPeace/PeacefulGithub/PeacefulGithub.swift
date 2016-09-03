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
struct User : JSONConvertible {
    var id:Int?
    var url:String?
    var login:String?
    
    static func fromJSON(json: JSON) -> User? {
        var owner = User()
        owner.id = json["id"].int
        owner.url = json["url"].string
        owner.login = json["login"].string
        return owner
    }
}

struct Repo : JSONConvertible {
    var id:Int?
    var name:String?
    var owner:User?
    static func fromJSON(json: JSON) -> Repo? {
        var repo = Repo()
        repo.id = json["id"].int
        repo.name = json["name"].string
        repo.owner <- json["owner"]
        return repo
    }
}

struct Commit : JSONConvertible {
    var sha:String?
    var commiter:User?
    var author:User?
    var message:String?
    
    static func fromJSON(json: JSON) -> Commit? {
        var commit = Commit()
        commit.sha = json["sha"].string
        commit.message = json["commit"]["message"].string
        commit.commiter <- json["commitor"]
        commit.author <- json["author"]
        return commit
    }
}


///Descriptor
var githubDescriptor:Descriptor = Descriptor().with {
    $0.baseURL = NSURL(string: "https://api.github.com/")
    $0.accept = "application/vnd.github.v3+json"
    //GithubAccessToken is .gitignore'd
    $0.authorization = "token \(GithubAccessToken)"
}

///Invoker
struct GithubInvoker: Invoker {
    typealias ObjectType = Repo
    var descriptor: Descriptor = githubDescriptor
    
    func repo(username:String) -> Model<[Repo]> {
        let URL = NSURL(string: "users/\(username)/repos", relativeToURL: descriptor.baseURL)!
        return Model<[Repo]>()
            .OnReload { model in
                self.requestJSONArray(model, URL:URL)
        }
    }
    
    //todo: should <Commit>
    func commits(repo:Repo) -> PaginatedSequenceModel<Commit> {
        let URL = NSURL(string: "repos/\(repo.owner!.login!)/\(repo.name!)/commits", relativeToURL: descriptor.baseURL)!
        
        return PaginatedSequenceModel<Commit>()
            .OnReload { (model) in
                self.requestJSONArray(model, URL: URL)
            }
            .OnReloadNextPage { (model) in
                if let linkString = model.response?.response?.allHeaderFields["Link"] as? String,
                   let nextURL = LinkHeader(value: linkString)["next"]
                {
                    self.requestJSONArray(model, URL: nextURL)
                } else {
                    model.noMoreToLoad = true
                }
        }
    }
}
