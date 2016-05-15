//
//  kakCameraViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/27/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class kakCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    @IBOutlet weak var currentImage: UIImageView!
    var currentImage: UIImage? = nil
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        
        
        // http://stackoverflow.com/questions/28373749/uiimagepickercontrollers-cameraoverlayview-is-offset-after-taking-photo
//        if (IPhone5 || IPhone5c || IPhone5s) {
//            imagePicker.cameraViewTransform = CGAffineTransformTranslate(imagePicker.cameraViewTransform, 0, 30);
//        }
//        else if (IPhone6 || IPhone6Plus) {
//            imagePicker.cameraViewTransform = CGAffineTransformTranslate(imagePicker.cameraViewTransform, 0, 44);
//        }
        
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                
                // TODO: if we want to use this, have to fix to not block off bottom buttin
                //Create camera overlay
//                let pickerFrame = CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.size.height, imagePicker.view.bounds.width, imagePicker.view.bounds.height - imagePicker.navigationBar.bounds.size.height - imagePicker.toolbar.bounds.size.height)
//                print("pickerFrame.width = \(pickerFrame.width)")
//                let squareFrame = CGRectMake(pickerFrame.width/2 - 300/2, pickerFrame.height/2 - 300/2, 300, 300)
//                UIGraphicsBeginImageContext(pickerFrame.size)
//                
//                let context = UIGraphicsGetCurrentContext()
//                CGContextSaveGState(context)
//                CGContextAddRect(context, CGContextGetClipBoundingBox(context))
//                CGContextMoveToPoint(context, squareFrame.origin.x, squareFrame.origin.y)
//                CGContextAddLineToPoint(context, squareFrame.origin.x + squareFrame.width, squareFrame.origin.y)
//                CGContextAddLineToPoint(context, squareFrame.origin.x + squareFrame.width, squareFrame.origin.y + squareFrame.size.height)
//                CGContextAddLineToPoint(context, squareFrame.origin.x, squareFrame.origin.y + squareFrame.size.height)
//                CGContextAddLineToPoint(context, squareFrame.origin.x, squareFrame.origin.y)
//                CGContextEOClip(context)
//                CGContextMoveToPoint(context, pickerFrame.origin.x, pickerFrame.origin.y)
//                CGContextSetRGBFillColor(context, 0, 0, 0, 1)
//                CGContextFillRect(context, pickerFrame)
//                CGContextRestoreGState(context)
//                
//                let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
//                UIGraphicsEndImageContext();
//                
//                let overlayView = UIImageView(frame: pickerFrame)
//                overlayView.image = overlayImage
//                imagePicker.cameraOverlayView = overlayView
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
            currentImage = pickedImage
            
            // Crop the image to a square
            // http://stackoverflow.com/questions/17712797/ios-custom-uiimagepickercontroller-camera-crop-to-square
            let imageSize = currentImage?.size
            let width = imageSize?.width
            let height = imageSize?.height
            if (width != height) {
                let newDimension = min(width!, height!)
                let widthOffset = (width! - newDimension) / 2
                let heightOffset = (height! - newDimension) / 2
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), false, 0)
                currentImage?.drawAtPoint(CGPoint(x: -widthOffset, y: -heightOffset), blendMode: CGBlendMode.Copy, alpha: 1.0)
                currentImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        
        
        imagePicker.dismissViewControllerAnimated(false, completion: {
            // Anything you want to happen when the user saves an image
            print("dismissedViewController")
            
            if let postKakNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("PostNewKakNavigation") as? UINavigationController {
                self.presentViewController(postKakNavigationController, animated: true, completion: {
                    print("presenting kak navigation controller")
                    if let postKakController = postKakNavigationController.viewControllers[0] as? PostNewKakViewController {
                        print(postKakController)
                        postKakController.kakImage.image = self.currentImage
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
