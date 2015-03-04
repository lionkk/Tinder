//
//  TinderViewController.swift
//  Tinder
//
//  Created by geine on 15/3/3.
//  Copyright (c) 2015年 isee. All rights reserved.
//

import UIKit

class TinderViewController: UIViewController {

    var xFormCenter:CGFloat = 0
    var UserNames = [String]()
    var UserImages = [NSData]()
    var CurrentUser = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint, error) -> Void in
            if error != nil {
                println(PFUser.currentUser().username)
                
                var query = PFUser.query()
                query.whereKey("location", nearGeoPoint:geoPoint)
                query.limit = 10
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    var accepted = [String]()
                    var rejected = [String]()
                    if PFUser.currentUser()["accepted"] != nil {
                        accepted = PFUser.currentUser()["accepted"] as [String]
                    }
                    if PFUser.currentUser()["rejected"] != nil {
                        var rejected = PFUser.currentUser()["rejected"] as [String]
                    }
                    
                    for user in users {
                        var gender1 = user["gender"] as? String
                        var gender2 = PFUser.currentUser()["InterestedIn"] as? String
                        
                        if gender1 == gender2 && user.username != PFUser.currentUser().username && contains(accepted, user.username) && !contains(rejected, user.username) {
                            self.UserNames.append(user.username)
                            self.UserImages.append(user["Image"] as NSData)
                        }
                    }
                    
                    var userImage = UIImageView(frame: CGRectMake(0, 64, self.view.frame.width, self.view.frame.height-64))
                    userImage.image = UIImage(data: self.UserImages[0])
                    userImage.contentMode = UIViewContentMode.ScaleAspectFit
                    self.view.addSubview(userImage)
                    
                    var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                    userImage.addGestureRecognizer(gesture)
                    userImage.userInteractionEnabled = true
                })
            }
        }
        
        
        
//        func addPerson(urlStr:String) {
//            var newUser = PFUser()
//            let url = NSURL(string: urlStr)
//            let urlRequest = NSURLRequest(URL: url!)
//            
//            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
//                let image = UIImage(data: data)
//                newUser["Image"] = data
//                newUser["gender"] = "female"
//                var location = PFGeoPoint(latitude: 37, longitude: -122)
//                newUser["location"] = location
//                newUser.username = "testAdd_4"
//                newUser.password = "password"
//                newUser.signUpInBackgroundWithBlock(nil)
//            }
//        }
//        
//        addPerson("http://picview01.baomihua.com/photos/20120726/m_14_634789177543750000_37635181.jpg")
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        var label = gesture.view!
        
        xFormCenter += translation.x
        var scale = min(100 / abs(xFormCenter), 1)
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFormCenter/200)
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        label.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if label.center.x < 100 {
                println("Unlike")
                PFUser.currentUser().addUniqueObject(UserNames[CurrentUser], forKey: "rejected")
                PFUser.currentUser().saveEventually(nil)
            } else if label.center.x > self.view.bounds.width - 100 {
                println("Like")
                PFUser.currentUser().addUniqueObject(UserNames[CurrentUser], forKey: "accepted")
                PFUser.currentUser().saveEventually(nil)
            }
            
            label.removeFromSuperview()
            
            if ++CurrentUser < UserImages.count {
                var userImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                userImage.image = UIImage(data: self.UserImages[CurrentUser])
                userImage.contentMode = UIViewContentMode.ScaleAspectFit
                self.view.addSubview(userImage)
                
                var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                userImage.addGestureRecognizer(gesture)
                userImage.userInteractionEnabled = true
                
                xFormCenter = 0;
            } else {
                println("no more users!")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
