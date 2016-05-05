//
//  kakCameraViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/27/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class kakCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var currentImage: UIImageView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
            } else {
                print("Rear camera doesn't exist: Application cannot access the camera.")
            }
        } else {
            print("Camera inaccessible: Application cannot access the camera.")
        }

        // Do any additional setup after loading the view.
    }
    
    func displayCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            presentViewController(imagePicker, animated: true, completion: {})
        }
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got an image")
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            currentImage.image = pickedImage
            
//            let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
//            UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
        }
        
        
        imagePicker.dismissViewControllerAnimated(false, completion: {
            // Anything you want to happen when the user saves an image
            print("dismissedViewController")
            
            if let postKakNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("PostNewKakNavigation") as? UINavigationController {
//                print("presenting new view controller")
//                if let postKakController = postKakNavigationController.viewControllers[0] as? PostNewKakViewController {
//                    postKakController.kakImage.image = self.currentImage.image
//                }
                self.presentViewController(postKakNavigationController, animated: true, completion: {
                    print("presenting kak navigation controller")
                    if let postKakController = postKakNavigationController.viewControllers[0] as? PostNewKakViewController {
                        print(postKakController)
                        postKakController.kakImage.image = self.currentImage.image
                    }
                })
            }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        // switch tab back to main screen
        self.tabBarController?.selectedIndex = 0
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
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
