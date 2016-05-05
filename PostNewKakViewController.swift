//
//  PostNewKakViewController.swift
//  Netwerk
//
//  Created by Juliana Cook on 4/28/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class PostNewKakViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var kakImage: UIImageView!
    @IBOutlet weak var kakCaption: UITextView!
    @IBOutlet weak var kakButton: UIButton!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.kakCaption.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostNewKakViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostNewKakViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func tappedCancel(sender: AnyObject) {
        print("tapped cancel")
        // switch tab back to main screen
        self.presentingViewController!.tabBarController?.selectedIndex = 0
//        self.tabBarController?.selectedIndex = 0
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.kakCaption.text = ""
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes return key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func tappedShare(sender: UIButton) {
        print("tapped share button")
        
        // TODO: add loading spinner
        
        
        let pictureData = UIImageJPEGRepresentation(kakImage.image!, 0.8)
        
        let file = PFFile(name: "image", data: pictureData!)
        file!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                // TODO: only exit on save if have error
                print("upload succeeded!")
                self.saveKak(file!);
            } else {
                // TODO: show error view
                print("upload failed")
            }
            }, progressBlock: { percent in
                print("Uploaded photo: \(percent)%")
        })
        
    }
    
    
    func saveKak(file: PFFile) {
        let wallPost = WallPost(image: file, user: PFUser.currentUser()!, comment: self.kakCaption.text)
        wallPost.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                // TODO: wait until photo has uploaded to move on, showing loading bar
                print("successfully saved kak")
                self.exitPostKakView()
            } else {
                if ((error?.userInfo["error"]) != nil) {
                    // TODO: show error
                    print("error saving kak")
                }
            }
        }
    }
    
    func exitPostKakView() {
        // dismiss current view controller
        let presentingViewController: UIViewController! = self.presentingViewController
        
        // dismiss current view controller
        if let tabBarController = self.presentingViewController as? UITabBarController {
            // switch tab back to main screen
            tabBarController.selectedIndex = 0
        }
        
        self.dismissViewControllerAnimated(false) {
            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
