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

class ProfileTableViewController: PFQueryTableViewController, UITextFieldDelegate {
    
    var posts: NSArray = [
        
        ["user": "Elizabeth Davis", "text": "Got the light patterns working :)", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url": "https://goo.gl/MTGtp1"]]
    
    var kaks = Array<Kak>() {
        didSet {
            //tableView.reloadData()
        }
    }
    
    func loadKaks() {
        for i in 1...posts.count {
            if let kak = Kak(data: posts[i-1] as? NSDictionary) {
                kaks.append(kak)
            }
        }
    }
    
    
    var searchText: String? {
        didSet {
            title = searchText
        }
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
        
        // TODO: change this to make a new kak, or have KakTableViewCell accept a KakPost
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