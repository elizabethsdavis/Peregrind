//
//  LoginViewController.swift
//  Netwerk
//
//  Created by Megan Faulk on 5/17/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class LoginViewController: PFLogInViewController {
    
    var backgroundImage : UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "login2"))
        backgroundImage.contentMode = UIViewContentMode.ScaleToFill
        self.logInView!.insertSubview(backgroundImage, atIndex: 0)
        
        // remove Parse label
        let logo = UILabel()
        logo.text = ""
        logInView?.logo = logo
        
        customizeButton(logInView?.facebookButton!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // stretch background image to fill screen
        backgroundImage.frame = CGRectMake( 0,  0,  self.logInView!.frame.width,  self.logInView!.frame.height)
        
        // customize Facebook login button
        logInView!.facebookButton!.sizeToFit()
        let logoFrame = logInView!.facebookButton!.frame
        logInView!.facebookButton!.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2 - (logoFrame.width/1.2)/2, logInView!.logo!.frame.origin.y - 10, logoFrame.width/1.2,  logoFrame.height*2)
        logInView?.facebookButton!.setTitle("login", forState: .Normal)
        logInView?.facebookButton!.titleLabel!.font = UIFont(name: "Avenir", size: 48)
        logInView?.facebookButton!.setImage(nil, forState: .Normal)

    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }

}
