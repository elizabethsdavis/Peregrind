//
//  kakCameraViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/27/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class kakCameraViewController: UIViewController, FusumaDelegate {

//    @IBOutlet weak var currentImage: UIImageView!
    var currentImage: UIImage? = nil
    
//    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let imagePicker: FusumaViewController! = FusumaViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.defaultMode = .Camera
        imagePicker.modeOrder = .CameraFirst
        
        // white background color scheme
//        fusumaBaseTintColor   = UIColor.hex("#9B9B9B", alpha: 1.0)
//        fusumaTintColor       = UIColor.hex("#A7C8F3", alpha: 1.0)
//        fusumaBackgroundColor = UIColor.hex("#FFFFFF", alpha: 1.0)
        
        // blue background color scheme
        fusumaBaseTintColor   = UIColor.hex("#9B9B9B", alpha: 1.0)
        fusumaTintColor       = UIColor.hex("#FFFFFF", alpha: 1.0)
        fusumaBackgroundColor = UIColor.hex("#A7C8F3", alpha: 1.0)
        
        
//        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
//            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
//                imagePicker.allowsEditing = false
//                imagePicker.sourceType = .Camera
//                imagePicker.cameraCaptureMode = .Photo
//            } else {
//                print("Rear camera doesn't exist: Application cannot access the camera.")
//            }
//        } else {
//            print("Camera inaccessible: Application cannot access the camera.")
//        }

    }
    
    func displayCamera() {
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
//        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
//            presentViewController(imagePicker, animated: true, completion: {})
//        }
    }
    
//    override func viewWillAppear(animated: Bool) {
//        print("camera view will appear")
//        super.viewWillAppear(animated)
//        // TODO: fix bug of reappearing 
//        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
//            presentViewController(imagePicker, animated: true, completion: {})
//        }
//        
//    }
    
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(image: UIImage) {
        
        print("Image selected")
        currentImage = image
        
    }
    
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after dismissed FusumaViewController")
        // chose image from image picker or from taking photo
        
        if let postKakNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("PostNewKakNavigation") as? UINavigationController {
            self.presentViewController(postKakNavigationController, animated: false, completion: {
                print("presenting kak navigation controller")
                if let postKakController = postKakNavigationController.viewControllers[0] as? PostNewKakViewController {
                    print(postKakController)
                    postKakController.kakImage.image = self.currentImage
                }
            })
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
        // Xed out view
        
        // switch tab back to main screen
        self.tabBarController?.selectedIndex = 0
        // TODO: is this necessary?
//        dismissViewControllerAnimated(true, completion: {
//            
//        })
    }

    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        print("Got an image")
//        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
//            currentImage = pickedImage
//        }
//        
//        
//        imagePicker.dismissViewControllerAnimated(false, completion: {
//            // Anything you want to happen when the user saves an image
//            print("dismissedViewController")
//            
//            if let postKakNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("PostNewKakNavigation") as? UINavigationController {
//                self.presentViewController(postKakNavigationController, animated: true, completion: {
//                    print("presenting kak navigation controller")
//                    if let postKakController = postKakNavigationController.viewControllers[0] as? PostNewKakViewController {
//                        print(postKakController)
//                        postKakController.kakImage.image = self.currentImage
//                    }
//                })
//            }
//        })
//    }
    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        print("User canceled image")
//        // switch tab back to main screen
//        self.tabBarController?.selectedIndex = 0
//        dismissViewControllerAnimated(true, completion: {
//            
//        })
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
