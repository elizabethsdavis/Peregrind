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
        backgroundImage = UIImageView(image: UIImage(named: "Splash Screen"))
        backgroundImage.contentMode = UIViewContentMode.ScaleToFill
        self.logInView!.insertSubview(backgroundImage, atIndex: 0)
        
        let logo = UILabel()
        logo.text = ""
        logInView?.logo = logo
        
        customizeButton(logInView?.facebookButton!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundImage.frame = CGRectMake( 0,  0,  self.logInView!.frame.width,  self.logInView!.frame.height)
        
        logInView!.facebookButton!.sizeToFit()
        let logoFrame = logInView!.facebookButton!.frame
        logInView!.facebookButton!.frame = CGRectMake(logoFrame.origin.x, logInView!.logo!.frame.origin.y + 36, logoFrame.width,  logoFrame.height)
    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }

}
