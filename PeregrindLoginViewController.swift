//
//  PeregrindLoginViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 5/5/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class PeregrindLoginViewController: UIViewController, PFLogInViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() == nil) {
            let loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            loginViewController.fields = .Facebook
            loginViewController.emailAsUsername = true
            self.presentViewController(loginViewController, animated: false, completion: { })
        } else {
            // if user already exists, make sure they have tags
            let query = Tag.query()
            query?.whereKey("user", equalTo: PFUser.currentUser()!)
            
            do {
                let tags = try query?.findObjects() as! [Tag]
                
                if (tags.count == 0) {
                    createInitialTag(PFUser.currentUser()!)
                }
            } catch {
                print("Error retrieving tags")
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("Progress After Login", sender: self)
        }
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Peregrind", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("Progress After Login", sender: self)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.fetchUserInfoFromFacebook()
        self.dismissViewControllerAnimated(true, completion: nil)
        presentLoggedInAlert()
    }
    
    func createInitialTag(currentUser: PFUser) {
        let userTag = Tag(user: currentUser, tagText: "My Photos")
        userTag.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                currentUser.addObject(userTag, forKey: User.userTags)
                currentUser.saveInBackground()
            } else {
                // There was a problem, check error.description
            }
        })
        
    }
    
    // from http://stackoverflow.com/questions/30252844/how-to-get-the-username-from-facebook-in-swift
    func fetchUserInfoFromFacebook(){
        if ((FBSDKAccessToken.currentAccessToken()) != nil){
            
            let request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
            request.startWithCompletionHandler({connection, result, error in
                if error == nil {
                    
                    //FACEBOOK DATA IN DICTIONARY
                    let userData = result as! NSDictionary
                    let userName = userData.objectForKey("name") as! String
                    let userId = userData.objectForKey(("id")) as! String
                    let userProfileImageURL = "https://graph.facebook.com/\(userId)/picture?width=100&height=100"
                    
                    
                    let currentUser : PFUser = PFUser.currentUser()!
                    currentUser.setObject(userId, forKey: "faceBookID")
                    currentUser.setObject(userName, forKey: "fullName")
                    currentUser.setObject(userProfileImageURL, forKey: "faceBookProfilePicURL")
                    currentUser.saveInBackground()
                    
                    self.createInitialTag(currentUser)
                }else{
                    print("Error getting facebook data")
                    //                    self.showErrorMessage(error)
                    //                    withcompletionHandler(success: false)
                }
            })
        }
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
