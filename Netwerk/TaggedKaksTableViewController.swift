//
//  TaggedKaksTableViewController.swift
//  Netwerk
//
//  Created by Juliana Cook on 5/18/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//


import UIKit

// TODO: Connect this with a the table view for tagged kaks
//       Might be able to just reuse the profile, so this might not be necessary
class TaggedKaksTableViewController: PFQueryTableViewController, UITextFieldDelegate {
    
    // TODO: must set this tag variable on segue to this view, so that it can be filtered
    var tag: Tag?
    
    var posts: NSArray = [["user": "", "text": "", "created_at":"", "id_str":"", "image_url":"", "video_url": ""]]
    
    var kaks = Array<Kak>()
    
    func loadKaks() {
        for i in 1...posts.count {
            if let kak = Kak(data: posts[i-1] as? NSDictionary) {
                kaks.append(kak)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        let query = KakPost.query()
        query?.whereKey("tag", equalTo: tag!)
        return query!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKaks()
    }
    
    private struct Storyboard {
        // TODO: change this if no longer using Profile View cells
        static let userKakCellIdentifier = "userKak"
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        // TODO: change this if no longer using Profile View cells
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
