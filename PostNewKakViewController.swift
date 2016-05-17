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
    
    let defaultMessage = "What did you learn today?"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.kakCaption.delegate = self
        self.kakButton.layer.cornerRadius = 5;
        self.kakCaption.text = defaultMessage

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostNewKakViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostNewKakViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
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
        if (self.kakCaption.text == "" || self.kakCaption.text == defaultMessage) {
            self.presentErrorAlert("Add a Caption", message: "Please write a caption before submitting!")
            return;
        }
        
        
        let pictureData = UIImageJPEGRepresentation(kakImage.image!, 0.8)
        loadingSpinner.startAnimating()
        kakButton.enabled = false
        
        let file = PFFile(name: "image", data: pictureData!)
        file!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                print("upload succeeded!")
                self.saveKak(file!);
            } else {
                print("upload failed")
                self.presentErrorAlert("Upload Failed", message: "There was an error while uploading your photo!")
                self.kakButton.enabled = true
            }
            }, progressBlock: { percent in
                print("Uploaded photo: \(percent)%")
        })
    }
    
    @IBAction func tappedCancel(sender: UIBarButtonItem) {
        dismissPostKakView()
    }
    
    func saveKak(file: PFFile) {
        let kakPost = KakPost(image: file, user: PFUser.currentUser()!, comment: self.kakCaption.text)
        kakPost.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                print("successfully saved kak")
                self.dismissPostKakView()
            } else {
                if ((error?.userInfo["error"]) != nil) {
                    self.presentErrorAlert("Upload Failed", message: "There was an error while uploading your photo!")
                    self.kakButton.enabled = true
                    print("error saving kak")
                    
                }
            }
        }
    }
    
    func presentErrorAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    
    func dismissPostKakView() {
        
        // dismiss current view controller
        if let tabBarController = self.presentingViewController as? UITabBarController {
            // switch tab back to main screen
            tabBarController.selectedIndex = 0
        }
        
        self.dismissViewControllerAnimated(false) {
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
