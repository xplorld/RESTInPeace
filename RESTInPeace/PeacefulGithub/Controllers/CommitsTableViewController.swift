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
            if let repo = repo {
                model = GithubInvoker().commits(repo)
                    .OnSuccess {[weak self] _ in
                        self?.tableView.reloadData()
                    }
                    .Finally { [weak self] _ in
                        self?.refreshControl?.endRefreshing()
                }
                navigationItem.title = repo.name
            } else {
                model = nil
                return
            }
        }
    }
    
    var model:PaginatedSequenceModel<Commit>? {
        didSet {
            reloadModel()
        }
    }
    func reloadModel() {
        model?.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(CommitsTableViewController.reloadModel), forControlEvents: UIControlEvents.ValueChanged);
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.value?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommitCell",forIndexPath: indexPath) as! CommitCell
        if let commit = model?.value?[indexPath.row] {
            cell.descLabel.text = commit.message
            cell.timeLabel.text = commit.date?.timeAgoSinceNow()
            cell.authorNameLabel.text = commit.author?.login
            loadImage(commit.author?.avatar_url) {
                cell.avatar.image = $0
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //remaining cell less than 5
        if tableView.numberOfRowsInSection(0) - indexPath.row < 2 {
            model?.loadNextPage()
        }
    }
}
