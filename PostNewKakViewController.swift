//
//  PostNewKakViewController.swift
//  Netwerk
//
//  Created by Juliana Cook on 4/28/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class PostNewKakViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var kakProjectTransparencyView: UIView!
    @IBOutlet weak var kakImage: UIImageView!
    @IBOutlet weak var kakCaption: UITextView!
    @IBOutlet weak var kakButton: UIButton!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var kakAlbumNameLabel: UILabel!
    
    /* Choose Project Pop-Up View Components */
    @IBOutlet weak var kakChooseProjectButton: UIButton!
    @IBOutlet weak var kakProjectDoneButton: UIButton!
    @IBOutlet weak var kakProjectView: UIView!
    @IBOutlet weak var kakProjectTextField: UITextField!
    @IBOutlet weak var kakProjectPicker: UIPickerView!
    let defaultMessage = "What did you learn today?"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.kakProjectTransparencyView.hidden = true
        self.kakProjectView.hidden = true
        self.kakCaption.delegate = self
        self.kakButton.layer.cornerRadius = 5;
        self.kakChooseProjectButton.layer.cornerRadius = 5;
        self.kakProjectDoneButton.layer.cornerRadius = 5;
        self.kakCaption.text = defaultMessage
        
        let caption = "Add to My Photos" as NSString
        let range = caption.rangeOfString("Add to ")
        let labelString = NSMutableAttributedString(string: caption as String)
        labelString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: range)
        kakAlbumNameLabel.attributedText = labelString;

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostNewKakViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostNewKakViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostNewKakViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.kakProjectPicker.delegate = self
        self.kakProjectPicker.dataSource = self
        pickerLabels = ["Create New..."]
        pickerData = [ nil ]
        
        let query = Tag.query()
        query?.whereKey("user", equalTo: PFUser.currentUser()!)
        
        do {
            if let tags = try query?.findObjects() as? [Tag] {
                for tag in tags {
                    pickerLabels.append(tag.tagText!)
                    pickerData.append(tag)
                    
                    if (tag.tagText! == "My Photos") {
                        chosenData = tag
                    }
                }
            }
        } catch {
            print("Error retrieving tags for currentUser")
        }
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
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (self.kakCaption.text == defaultMessage) {
            self.kakCaption.text = ""
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes return key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    var chosenData: Tag?
    var chosenLabel: String = "My Photos"
    
    @IBAction func tappedChooseProject(sender: UIButton) {
        dismissKeyboard()
        kakProjectView.hidden = false
        kakProjectTransparencyView.hidden = false
    }
    
    func createNewTag(tagText: String, user: PFUser) -> Tag{
        let userTag = Tag(user: user, tagText: tagText)
        
        do {
            try userTag.save()
            user.addObject(userTag, forKey: User.userTags)
            try user.save()
            
        } catch {
            print("Error saving newly created user tag")
        }
        
        return userTag
    }
    
    @IBAction func tappedDone(sender: AnyObject) {
        dismissKeyboard()
        kakProjectView.hidden = true
        kakProjectTransparencyView.hidden = true
        
        // Save the current label and tag data, make new tag if needed
        let selectedIndex = kakProjectPicker.selectedRowInComponent(0)
        if (selectedIndex == 0) {
            // Picked the "Create New..." option, must check they wrote something
            if (!(kakProjectTextField.text ?? "").isEmpty) {
                // create a new tag and save it for the user
                chosenData = createNewTag(kakProjectTextField.text!, user: PFUser.currentUser()!)
                chosenLabel = kakProjectTextField.text!
                
            } else {
                // didn't write anything, do nothing and default to whatever they chose before
            }
            
        } else {
            chosenData = pickerData[selectedIndex]
            chosenLabel = pickerLabels[selectedIndex]
        }
        
        
        // Update label on add new kak screen
        var caption: NSString
        if (!(chosenLabel ?? "").isEmpty) {
            caption = "Add to " + chosenLabel
        } else {
            caption = "Add to My Photos"
        }
        
        let range = caption.rangeOfString("Add to ")
        let labelString = NSMutableAttributedString(string: caption as String)
        labelString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: range)
        kakAlbumNameLabel.attributedText = labelString;
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
    
    @IBAction func editingPostNameChanged(sender: UITextField) {
        kakProjectPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    func saveKak(file: PFFile) {
        let kakPost = KakPost(image: file, user: PFUser.currentUser()!, comment: self.kakCaption.text, tag: chosenData)
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
    
    var pickerLabels: [String] = [String]()
    var pickerData: [Tag?] = [Tag?]()
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerLabels[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let label = row == 0 ? "" : pickerLabels[row]
        kakProjectTextField.text = label
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
