//
//  KakTableViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/25/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class KakTableViewController: PFQueryTableViewController, UITextFieldDelegate {
    
    var posts: NSArray = [["user": "", "text": "", "created_at": "", "id_str": "", "image_url": "", "video_url": ""]]
        
    var kaks = Array<Kak>() {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        return query!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("KakTableViewController_viewDidLoad")
        self.paginationEnabled = false
        
        loadKaks()
        let image = UIImage(named: Storyboard.peregrindLogoImageAssetName)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
    }

    private struct Storyboard {
        static let kakCellIdentifier = "Kak"
        static let peregrindLogoImageAssetName = "Peregrind Logo"
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        let kakCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.kakCellIdentifier, forIndexPath: indexPath) as! KakTableViewCell
        let kakPost = object as! KakPost
        
        let kak = kaks[0]
        kakCell.kakImageView.file = kakPost.image
        kak.text = kakPost.comment!
        kakCell.kakPostLabel.numberOfLines = 0;
        kakCell.kakPostLabel.lineBreakMode = .ByWordWrapping;
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            kak.imageURL = NSURL(string: kakPost.user.objectForKey("faceBookProfilePicURL") as! String)!
            kak.user = kakPost.user.objectForKey("fullName") as! String
            kakCell.kakImageView.loadInBackground(nil) { percent in
                print("\(percent)% image loaded")
            }
            dispatch_async(dispatch_get_main_queue()) {
                kakCell.kak = kak
            }
        }

        
        
        // TODO: set the label for the tag, something along the lines of this once there is a label in the storyboard
//        if let tagText = kakPost.tag?.tagText {
//            kakCell.kakTagLabel = tagText
//        }
        
        return kakCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: add segue to table view of other posts with same tag as this post
        
        // right now this is just a demo showing how to print out the tag name of a given post
        // the "Options are great" post by Juliana has a tag titled "Flight Time"
        
        let kakPost = self.objectAtIndexPath(indexPath) as! KakPost
        
        if kakPost.tag != nil {
            let tagText = kakPost.tag!.tagText
            print(tagText)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // TODO: replace with actual segue identifier
        if segue.identifier == "mySegue" {
            // TODO: change if don't use TaggedKaksTableVC
            let nextScene =  segue.destinationViewController as! TaggedKaksTableViewController
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let kakPost = self.objectAtIndexPath(indexPath) as! KakPost
                nextScene.tag = kakPost.tag
            }
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        Flurry.logEvent("KakTableViewController_scrollViewWillBeginDragging")
    }
    
    
}
