//
//  ProfileTableViewController.swift
//  Netwerk
//
//  Created by Juliana Cook on 5/13/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//
//
//  KakTableViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/25/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class ProfileTableViewController: PFQueryTableViewController, UITextFieldDelegate, ProfileProjectHeaderTableViewCellDelegate {
    
    var posts: NSArray = [["user": "", "text": "", "created_at":"", "id_str":"", "image_url":"", "video_url": ""]]
    
    var kaks = Array<Kak>()
    
    func loadKaks() {
        for i in 1...posts.count {
            if let kak = Kak(data: posts[i-1] as? NSDictionary) {
                kaks.append(kak)
            }
        }
    }
    
    var sections: [Int: [PFObject]] = Dictionary()
    var sectionKeys: [Int] = Array()
    
    // MARK: Init
    
    convenience init(className: String?) {
        self.init(style: .Plain, className: className)
        
        title = "Sectioned Table"
        pullToRefreshEnabled = true
    }
    
    var tagIndexes: [String] = ["My Photos"]
    
    // MARK: Data
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        sections.removeAll(keepCapacity: false)
        if let objects = objects {
            for object in objects {
                var sectionNumber: Int?
                if let tag = object["tag"] as? Netwerk.Tag {
                    if let tagText = tag.tagText {
                        if tagIndexes.contains(tagText) {
                            sectionNumber = tagIndexes.indexOf(tagText)!
                        } else {
                            tagIndexes.append(tagText)
                            sectionNumber = tagIndexes.indexOf(tagText)!
                        }
                    }
                }
                if sectionNumber == nil {
                    sectionNumber = 0
                }
                var array = sections[sectionNumber!] ?? Array()
                array.append(object)
                sections[sectionNumber!] = array
            }
        }
        sectionKeys = sections.keys.sort(<)
        tableView.reloadData()
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        if let indexPath = indexPath {
            let array = sections[sectionKeys[indexPath.section]]
            return array?[indexPath.row]
        }
        return nil
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        let query = KakPost.query()
        query?.whereKey("user", equalTo: PFUser.currentUser()!)
        return query!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKaks()
    }
    
    private struct Storyboard {
        static let userKakCellIdentifier = "userKak"
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        let kakCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.userKakCellIdentifier, forIndexPath: indexPath) as! ProfileViewCell
        let kakPost = object as! KakPost
        
        let kak = kaks[0]
        kakCell.kakImageView.file = kakPost.image
        kak.text = kakPost.comment!
        kakCell.kakPostLabel.numberOfLines = 0;
        kakCell.kakPostLabel.lineBreakMode = .ByWordWrapping;
        
        kakCell.kakImageView.loadInBackground(nil) { percent in
            print("\(percent)% image loaded")
        }
        
        kakCell.kak = kak
        
        return kakCell
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = sections[sectionKeys[section]]
        return array?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tagIndexes[section])"
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCellWithIdentifier("projectHeader")! as! ProfileProjectHeaderTableViewCell
        header.delegate = self
        
        //And populate the header with the name of the account
        header.projectHeaderButton?.setTitle(tagIndexes[section], forState: UIControlState.Normal)
        //        header.projectHeaderButton?.currentTitle = tagIndexes[section]
        //        header.textLabel?.textColor = UIColor.blackColor()
        //        header.contentView.backgroundColor = UIColor.whiteColor()
        return header
    }
    
    func didSelectProfileProjectHeaderTableViewCell(Selected: Bool, ProfileProjectHeader: ProfileProjectHeaderTableViewCell) {
        print("Cell Selected!");
        performSegueWithIdentifier("showProjectPosts", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProjectPosts" {
            if let cell = sender as? ProfileProjectHeaderTableViewCell {
                let project = cell.projectHeaderButton.currentTitle
                if let tvc =  segue.destinationViewController as? ProfileProjectTableViewController {
                    print("project is \(project)")
                    tvc.project = project
                }
            }
        }
    }
}

