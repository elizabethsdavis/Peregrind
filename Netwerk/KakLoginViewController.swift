//
//  KakLoginViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 5/4/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class KakLoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.fetchUserInforFromFacebook() // TODO: remove
            performSegueWithIdentifier("Proceed After Login", sender: self)
        } else {
            self.view.addSubview(loginButton)
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.delegate = self
        }
    }
    
    var FBSDKLoginSuccess = false
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil || FBSDKLoginSuccess == true)
        {
            self.fetchUserInforFromFacebook() // TODO: remove
            performSegueWithIdentifier("Proceed After Login", sender: self)
        }
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                self.fetchUserInforFromFacebook()
                self.performSegueWithIdentifier("Proceed After Login", sender: self)
            }
            FBSDKLoginSuccess = true
            print("here we are")
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    // from http://stackoverflow.com/questions/30252844/how-to-get-the-username-from-facebook-in-swift
    func fetchUserInforFromFacebook(){
        if ((FBSDKAccessToken.currentAccessToken()) != nil){
            
            let request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
            request.startWithCompletionHandler({connection, result, error in
                if error == nil {
                    
                    //FACEBOOK DATA IN DICTIONARY
                    let userData = result as! NSDictionary
                    let currentUser : PFUser = PFUser.currentUser()!
                    currentUser.setObject(userData.objectForKey("id") as! String, forKey: "faceBookID")
                    currentUser.setObject( userData.objectForKey("name") as! String, forKey: "fullName")
                    currentUser.saveInBackground()
                    
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
