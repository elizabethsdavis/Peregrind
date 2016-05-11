//
//  KakTableViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/25/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class KakTableViewController: PFQueryTableViewController, UITextFieldDelegate {
    
    var posts: NSArray = [
        
         ["user": "Elizabeth Davis", "text": "Got the light patterns working :)", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url": "https://goo.gl/MTGtp1"],
    
        ["user": "Juliana Cook", "text": "Finally finished with Xylo!", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/KfKt6R"],
       
         ["user": "Josh Moss", "text": "The probability struggle is real :(", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://media.licdn.com/media/p/5/000/230/1d2/17e88ce.jpg", "video_url":"https://goo.gl/UM5XcE"],

        ["user": "Juliana Cook", "text": "so close", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/660Kug"],
        
        ["user": "Elizabeth Davis", "text": "Making an LED rainbow!", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url": "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQr_5A8C1iAFPGDVMbgK_SEOffDmlWEN6PtDCtsdt1Ea2AYNmUg"],
        
        
        ["user": "Juliana Cook", "text": "Machining in the PRL for daysss", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/NMJVzk"],
        
        
        ["user": "Juliana Cook", "text": "First music box prototype!", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/lZeoQf"]]
        
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
        return query!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // TODO: change this to make a new kak, or have KakTableViewCell accept a KakPost
        let kak = kaks[0]
        kakCell.kakImageView.file = kakPost.image
        kak.text = kakPost.comment!
        kak.imageURL = NSURL(string: kakPost.user.objectForKey("faceBookProfilePicURL") as! String)!
        kak.user = kakPost.user.objectForKey("fullName") as! String
        
        kakCell.kakImageView.loadInBackground(nil) { percent in
            print("\(percent)% image loaded")
        }
        
        kakCell.kak = kak
        
        return kakCell
    }
}
