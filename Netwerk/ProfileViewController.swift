//
//  ProfileViewController.swift
//  Netwerk
//
//  Created by Megan Faulk on 5/3/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//


import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    var posts: NSArray = [["user": "", "text": "", "created_at":"", "id_str":"", "image_url":"", "video_url":""]]

    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var userImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("ProfileViewController_viewDidLoad")
        
        usernameLabel.text = (PFUser.currentUser()?.objectForKey("fullName") as! String)
        let facebookPhotoURL = NSURL(string: PFUser.currentUser()!.objectForKey("faceBookProfilePicURL") as! String)!
        downloadImage(facebookPhotoURL, toImageView: userImage)
        
        setProfileImageView(userImage)
        let image = UIImage(named: Storyboard.peregrindLogoImageAssetName)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
    }
    
    
    private struct Storyboard {
        static let kakCellIdentifier = "userKak"
        static let peregrindLogoImageAssetName = "Peregrind Logo"
    }
    
    private func setProfileImageView(imageView: UIImageView) {
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.cornerRadius = 13
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
    }
    
    private func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    private func downloadImage(url: NSURL, toImageView imageView: UIImageView){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                imageView.image = UIImage(data: data)
            }
        }
    }
}
