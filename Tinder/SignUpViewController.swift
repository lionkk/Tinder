//
//  SignUpViewController.swift
//  Tinder
//
//  Created by geine on 15/3/3.
//  Copyright (c) 2015年 isee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var ProfileImageView: UIImageView!
    
    @IBOutlet var GenderSwitch: UISwitch!
    
    @IBAction func SignUpPress(sender: AnyObject) {
        var user = PFUser.currentUser()
        
        if GenderSwitch.on {
            user["InterestedIn"] = "female"
        } else {
            user["InterestedIn"] = "male"
        }
        user.saveInBackgroundWithBlock(nil)
        
        self.performSegueWithIdentifier("signedUp", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser.currentUser()

        var FBSession = PFFacebookUtils.session()
        var accessToken = FBSession.accessTokenData.accessToken
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            let image = UIImage(data: data)
            self.ProfileImageView.image = image
            user["Image"] = data
            user.saveInBackgroundWithBlock(nil)
            
            FBRequestConnection.startForMeWithCompletionHandler({ (connection, result, error) -> Void in
                user["gender"] = result["gender"]
                user["name"] = result["name"]
                user["email"] = result["email"]
                user.saveInBackgroundWithBlock(nil)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
