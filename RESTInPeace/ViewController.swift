//
//  ViewController.swift
//  RESTInPeace
//
//  Created by Xplorld on 2016/8/30.
//  Copyright © 2016年 xplorld. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GithubInvoker().repo("xplorld")
        .OnSuccess { (response) in
            var arr = response.object ?? []
            print(arr.count)
            print(arr)
        }
        .OnFailure { (response) in
            var err = response.object
            print(err)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

