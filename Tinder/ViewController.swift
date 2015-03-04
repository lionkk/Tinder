//
//  ViewController.swift
//  Tinder
//
//  Created by geine on 15/3/2.
//  Copyright (c) 2015年 isee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var LoginCancelLabel: UILabel!

    @IBAction func fbLoginPress(sender: AnyObject) {
        var permissions = ["email", "public_profile"]
        self.LoginCancelLabel.alpha = 0
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
                self.performSegueWithIdentifier("signUp", sender: self)
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
                self.LoginCancelLabel.alpha = 1
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var loginView = FBLoginView()
//        loginView.center = self.view.center
//        self.view.addSubview(loginView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

