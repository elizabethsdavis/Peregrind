//
//  KakTableViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/25/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class KakTableViewController: PFQueryTableViewController, UITextFieldDelegate {
    
    // TODO: want to make this pull from backend instead of hardcoded data
    var kaks = Array<Kak>() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var posts: NSArray = [
        
            ["user": "Elizabeth Davis", "text": "Making an LED rainbow!", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url": "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQr_5A8C1iAFPGDVMbgK_SEOffDmlWEN6PtDCtsdt1Ea2AYNmUg"],
    
    
            ["user": "Juliana Cook", "text": "Machining in the PRL for daysss", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/NMJVzk"],


            ["user": "Juliana Cook", "text": "First music box prototype!", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/lZeoQf"],
    
            ["user": "Samuel Hinshelwood", "text": "Learning is everything <3", "created_at":"04/05/2016", "id_str":"0002", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/10649571_10206228274366972_5329742365679361816_n.jpg?oh=3f65c56edc39b7cebbaefa7a3ab585aa&oe=579E333D", "video_url":"https://www.youtube.com/embed/YGV6NkKDJ4o"],
    
            ["user": "Julien Brinson", "text": "I like learning a lot :)", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/v/t1.0-9/19181_10202609887128470_9124914537994045659_n.jpg?oh=40b5d4c1e86bf4a37b5843b964ceb328&oe=57BC9A1D", "video_url":"https://www.youtube.com/embed/3q8tkoqdAlU"],
    
            ["user": "Elizabeth Davis", "text": "I absolutely love to learn!!!", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url":"https://www.youtube.com/embed/TsD5QJmz0gA"],
    
            ["user": "Samuel Hinshelwood", "text": "Learning is everything <3", "created_at":"04/05/2016", "id_str":"0002", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/10649571_10206228274366972_5329742365679361816_n.jpg?oh=3f65c56edc39b7cebbaefa7a3ab585aa&oe=579E333D", "video_url":"https://www.youtube.com/embed/YGV6NkKDJ4o"],
    
            ["user": "Julien Brinson", "text": "I like learning a lot :)", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/v/t1.0-9/19181_10202609887128470_9124914537994045659_n.jpg?oh=40b5d4c1e86bf4a37b5843b964ceb328&oe=57BC9A1D", "video_url":"https://www.youtube.com/embed/3q8tkoqdAlU"],
        ]
    
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
//            loadKaks()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
        print("viewWillAppear")
    }
    
    override func queryForTable() -> PFQuery {
        let query = WallPost.query()
        return query!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadKaks()
        
        // set top bar image to have Peregrind logo
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
    
    
    // MARK: - Table view data source
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        print("\(kaks.count) sections in table view")
//        return kaks.count
//    }
////    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10.0
//    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        let kakCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.kakCellIdentifier, forIndexPath: indexPath) as! KakTableViewCell
        
        let wallPost = object as! WallPost
        
        
        // TODO: remove this
        // this is just an easy way to get a kak format since the table cell expects
        // things like a profile picture that the mock data I'm pulling doesn't have;
        // eventually want to remove the posts array entirely and just pull from the 
        // backend
        let kak = kaks[0]
        kakCell.kakImageView.file = wallPost.image
        kakCell.kakImageView.loadInBackground(nil) { percent in
            // TODO: possibly add a progress view and update here
            print("\(percent)% loaded")
        }

        
        // TODO: set the image from the backend
        
        kakCell.kak = kak
        
        
        
        
//        let wallPost = object as! WallPost
//        
//        cell.postImage.file = wallPost.image
//        cell.postImage.loadInBackground(nil) { percent in
//            cell.progressView.progress = Float(percent)*0.01
//            print("\(percent)%")
//        }
//        
//        let creationDate = wallPost.createdAt
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "HH:mm dd/MM yyyy"
//        let dateString = dateFormatter.stringFromDate(creationDate!)
//        
//        if let username = wallPost.user.username {
//            cell.createdByLabel.text = "Uploaded by: \(username), \(dateString)"
//        } else {
//            cell.createdByLabel.text = "Uploaded by anonymous: , \(dateString)"
//        }
//        
//        cell.createdByLabel.text = "Uploaded by: \(wallPost.user.username), \(dateString)"
//        
//        cell.commentLabel.text = wallPost.comment
//        
        return kakCell
    }

    
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.kakCellIdentifier, forIndexPath: indexPath)
//        
//        // TODO
////        cell.textLabel?.text = posts[indexPath.item] as? String
//        
//        let kak = kaks[indexPath.section]
//        
//        if let kakCell = cell as? KakTableViewCell {
//            kakCell.kak = kak
//            
//        }
//        
//        return cell
//    }
    
    
    
    
    
    
    
    
    
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 300.0
    //    }
    
    //    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    //
    //
    //        cell.contentView.backgroundColor = UIColor.whiteColor()
    //
    //        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height))
    //
    //        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
    //        whiteRoundedView.layer.masksToBounds = false
    //        whiteRoundedView.layer.cornerRadius = 2.0
    //        whiteRoundedView.layer.shadowOffset = CGSizeMake(0, 1)
    //        whiteRoundedView.layer.shadowOpacity = 0.2
    //
    //        cell.contentView.addSubview(whiteRoundedView)
    //        cell.contentView.sendSubviewToBack(whiteRoundedView)
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}








// ======================================== OLD CODE BELOW THIS LINE


//import UIKit
//
//class KakTableViewController: UITableViewController, UITextFieldDelegate {
//
//    
//    
////    @IBOutlet weak var searchTextField: UITextField! {
////        didSet {
////            searchTextField.delegate = self
////            searchTextField.text = searchText
////        }
////    }
////    
////    func textFieldShouldReturn(textField: UITextField) -> Bool {
////        textField.resignFirstResponder()
////        searchText = textField.text
////        return true
////    }
//    
// 
//    
//    var posts: NSArray = [
//        
//         ["user": "Elizabeth Davis", "text": "Got the light patterns working :)", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url": "https://goo.gl/MTGtp1"],
//        
////
//        
//        ["user": "Juliana Cook", "text": "Finally finished with Xylo!", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/KfKt6R"],
////        
//         ["user": "Josh Moss", "text": "The probability struggle is real :(", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://media.licdn.com/media/p/5/000/230/1d2/17e88ce.jpg", "video_url":"https://goo.gl/UM5XcE"],
////
//        ["user": "Juliana Cook", "text": "so close", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/660Kug"],
//        
//        ["user": "Elizabeth Davis", "text": "Making an LED rainbow!", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url": "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQr_5A8C1iAFPGDVMbgK_SEOffDmlWEN6PtDCtsdt1Ea2AYNmUg"],
//        
//        
//        ["user": "Juliana Cook", "text": "Machining in the PRL for daysss", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/NMJVzk"],
//        
//        
//        ["user": "Juliana Cook", "text": "First music box prototype!", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/lZeoQf"],
//        
//        
//        
//        
//        
//            
//        
////        ["user": "Elizabeth Davis", "text": "Making an LED rainbow!", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url": "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQr_5A8C1iAFPGDVMbgK_SEOffDmlWEN6PtDCtsdt1Ea2AYNmUg"],
////            
////            // "video_url":"https://www.youtube.com/embed/TsD5QJmz0gA"],
////        
////                ["user": "Juliana Cook", "text": "Machining in the PRL for daysss", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/NMJVzk"],
////        
////        
////                ["user": "Juliana Cook", "text": "First music box prototype!", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/lZeoQf"],
////        
////        ["user": "Samuel Hinshelwood", "text": "Learning is everything <3", "created_at":"04/05/2016", "id_str":"0002", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/10649571_10206228274366972_5329742365679361816_n.jpg?oh=3f65c56edc39b7cebbaefa7a3ab585aa&oe=579E333D", "video_url":"https://www.youtube.com/embed/YGV6NkKDJ4o"],
////        
////        ["user": "Julien Brinson", "text": "I like learning a lot :)", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/v/t1.0-9/19181_10202609887128470_9124914537994045659_n.jpg?oh=40b5d4c1e86bf4a37b5843b964ceb328&oe=57BC9A1D", "video_url":"https://www.youtube.com/embed/3q8tkoqdAlU"],
////        
////        ["user": "Elizabeth Davis", "text": "I absolutely love to learn!!!", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url":"https://www.youtube.com/embed/TsD5QJmz0gA"],
////        
////        ["user": "Samuel Hinshelwood", "text": "Learning is everything <3", "created_at":"04/05/2016", "id_str":"0002", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/10649571_10206228274366972_5329742365679361816_n.jpg?oh=3f65c56edc39b7cebbaefa7a3ab585aa&oe=579E333D", "video_url":"https://www.youtube.com/embed/YGV6NkKDJ4o"],
////        
////        ["user": "Julien Brinson", "text": "I like learning a lot :)", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/v/t1.0-9/19181_10202609887128470_9124914537994045659_n.jpg?oh=40b5d4c1e86bf4a37b5843b964ceb328&oe=57BC9A1D", "video_url":"https://www.youtube.com/embed/3q8tkoqdAlU"],
//    ]
//    
//    var kaks = Array<Kak>() {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//    
//    func loadKaks() {
////        var kakPost = [Kak]()
//        for i in 1...posts.count {
//            if let kak = Kak(data: posts[i-1] as? NSDictionary) {
//                kaks.append(kak)
//            }
//        }
////        kaks.append(kakPost)
//    }
//
//   
//    var searchText: String? {
//        didSet {
//            title = searchText
//            loadKaks()
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadKaks()
//        let image = UIImage(named: Storyboard.peregrindLogoImageAssetName)
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        imageView.contentMode = .ScaleAspectFit
//        imageView.image = image
//        self.navigationItem.titleView = imageView
//    }
//
//    private struct Storyboard {
//        static let kakCellIdentifier = "Kak"
//        static let peregrindLogoImageAssetName = "Peregrind Logo"
//    }
//
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return kaks.count
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10.0
//    }
//
//  
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.kakCellIdentifier, forIndexPath: indexPath)
//        cell.textLabel?.text = posts[indexPath.item] as? String
//
//        let kak = kaks[indexPath.section]
//        
//        if let kakCell = cell as? KakTableViewCell {
//            kakCell.kak = kak
//        }
//       
//        return cell
//    }
//    
////    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
////        return 300.0
////    }
//    
////    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
////        
////
////        cell.contentView.backgroundColor = UIColor.whiteColor()
////        
////        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height))
////    
////        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
////        whiteRoundedView.layer.masksToBounds = false
////        whiteRoundedView.layer.cornerRadius = 2.0
////        whiteRoundedView.layer.shadowOffset = CGSizeMake(0, 1)
////        whiteRoundedView.layer.shadowOpacity = 0.2
////        
////        cell.contentView.addSubview(whiteRoundedView)
////        cell.contentView.sendSubviewToBack(whiteRoundedView)
////    }
//   
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
