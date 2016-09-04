//
//  RepositoryListTableViewController.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/31.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import UIKit

class RepositoryListTableViewController: UITableViewController {
    @IBAction func onRefresh(sender: AnyObject) {
        model.reload()
    }
    
    var model:Model<[Repo]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        model =
            GithubInvoker().repo("xplorld")
                .OnSuccess {
                    [weak self] _ in
                    self?.tableView.reloadData()
                }
                .OnFailure { err in
                    //HUD
                    print(err)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        model.reload()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RepoCell", forIndexPath: indexPath) as! RepoCell
        if let repo = model.value?[indexPath.row] {
            cell.repoNameLabel.text = repo.name
            cell.descLabel.text = repo.description
            cell.forkNumLabel.text = "\(repo.forks_count ?? 0)"
            cell.starNumLabel.text = "\(repo.stargazers_count ?? 0)"
            loadImage(repo.owner?.avatar_url) {
                cell.avatar.image = $0
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.value?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("RepoToCommitsSeque", sender: indexPath)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RepoToCommitsSeque",
            let indexPath = sender as? NSIndexPath,
            let repo = model.value?[indexPath.row] {
            let vc = segue.destinationViewController as! CommitsTableViewController
            vc.repo = repo
        }
    }
}
