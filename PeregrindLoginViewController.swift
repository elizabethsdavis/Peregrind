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
        Flurry.logEvent("PeregrindLoginViewController_viewDidLoad")
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() == nil) {
            //let loginViewController = PFLogInViewController()
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            loginViewController.fields = .Facebook
            loginViewController.emailAsUsername = true
            self.presentViewController(loginViewController, animated: false, completion: { })
        } else {
            let userId = PFUser.currentUser()?.objectForKey("faceBookID") as! String
            Flurry.setUserID(userId)
            
            // ensure that user has tags
            self.createInitialTags(PFUser.currentUser()!)
            
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
    
    func createInitialTags(currentUser: PFUser) {
        let query = Tag.query()
        query?.whereKey("user", equalTo: currentUser)
        
        do {
            let tags = try query?.findObjects() as! [Tag]
            
            if (tags.count == 0) {
                let userTag = Tag(user: currentUser, tagText: "My Photos")
                do {
                    try userTag.save()
                } catch {
                    Flurry.logError("Error creating initial tags", message: "", exception: nil);
                }
            }
        } catch {
            print("Error retrieving tags")
        }
        
        
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
                    Flurry.setUserID(userId)
                    
                    do {
                        try currentUser.save()
                        self.createInitialTags(currentUser)
                    } catch {
                        Flurry.logError("Error creating initial tags", message: "", exception: nil);
                    }
                }else{
                    print("Error getting facebook data")
                    Flurry.logError("Error getting facebook data", message: "", exception: nil);
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
