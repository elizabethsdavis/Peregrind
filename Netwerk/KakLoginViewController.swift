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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
