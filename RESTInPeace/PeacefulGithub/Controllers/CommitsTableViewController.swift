//
//  CommitsTableViewController.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/9/3.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import UIKit

class CommitsTableViewController: UITableViewController {
    
    var repo:Repo? {
        didSet {
            guard let repo = repo else {model = nil;return}
            
            model = GithubInvoker().commits(repo)
                        .OnSuccess {[weak self] _ in
                            self?.tableView.reloadData()
                        }
        }
    }
    
    var model:PaginatedSequenceModel<Commit>? {
        didSet {
            model?.reload()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.value?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commitCell")!
        let commit = model?.value?[indexPath.row]
        cell.textLabel?.text = commit?.message
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //remaining cell less than 5
        if tableView.numberOfRowsInSection(0) - indexPath.row < 1 {
            model?.loadNextPage()
        }
    }
}
