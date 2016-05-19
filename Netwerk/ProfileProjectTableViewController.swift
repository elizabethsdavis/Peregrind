//
//  ProfileProjectTableViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 5/18/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class ProfileProjectTableViewController: PFQueryTableViewController, UITextFieldDelegate {
    
    var project: String? {
        didSet {
            print("SET PROJECT")
        }
    }
    
    var posts: NSArray = [["user": "", "text": "", "created_at":"", "id_str":"", "image_url":"", "video_url": ""]]
    
    var kaks = Array<Kak>()
    
    func loadKaks() {
        for i in 1...posts.count {
            if let kak = Kak(data: posts[i-1] as? NSDictionary) {
                kaks.append(kak)
            }
        }
    }
    
    // MARK: Data
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        let query = KakPost.query()?.whereKey("user", equalTo: PFUser.currentUser()!)
        if let projectName = project {
            print("setting project")
            query!.whereKey("tag", equalTo: projectName)
        }
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
}
