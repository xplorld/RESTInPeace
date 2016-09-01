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
        model =
            GithubInvoker().repo("xplorld")
                .OnSuccess {
                    print("----------------------")
                    print($0)
                    print("----------------------")
                    self.tableView.reloadData()
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.value?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = model.value?[indexPath.row].name
        return cell
    }
}
