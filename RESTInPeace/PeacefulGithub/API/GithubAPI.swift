//
//  PeacefulGithub.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import UIKit
import SwiftyJSON

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
