//
//  ProfileViewController.swift
//  Netwerk
//
//  Created by Megan Faulk on 5/3/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//


import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: Properties
    var posts: NSArray = [
        
        
        ["user": "Juliana Cook", "text": "Finally finished with Xylo!", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/KfKt6R"],
        ["user": "Juliana Cook", "text": "so close", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/660Kug"],
        
        
        
        ["user": "Juliana Cook", "text": "Machining in the PRL for daysss", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/NMJVzk"],
        
        
        ["user": "Juliana Cook", "text": "First music box prototype!", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/lZeoQf"],
    ]
    

    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userPosts: UITableView!
    
    var kaks = Array<Kak>() {
        didSet {
            userPosts.reloadData()
        }
    }
    
    func loadKaks() {
        for i in 1...posts.count {
            if let kak = Kak(data: posts[i-1] as? NSDictionary) {
                kaks.append(kak)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKaks()
        if let kak = Kak(data: posts[0] as? NSDictionary) {
            usernameLabel.text = kak.user
            downloadImage(kak.imageURL, toImageView: userImage)
        }
        setProfileImageView(userImage)
        let image = UIImage(named: Storyboard.peregrindLogoImageAssetName)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        
        userPosts.delegate = self
        userPosts.dataSource = self

    }
    
    
    private struct Storyboard {
        static let kakCellIdentifier = "userKak"
        static let peregrindLogoImageAssetName = "Peregrind Logo"
    }
    
    private func setProfileImageView(imageView: UIImageView) {
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.cornerRadius = 13
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
    }
    
    private func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    private func downloadImage(url: NSURL, toImageView imageView: UIImageView){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kaks.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.kakCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = posts[indexPath.item] as? String
        
        let kak = kaks[indexPath.section]
        
        if let kakCell = cell as? ProfileViewCell {
            kakCell.kak = kak
        }
        
        return cell
    }

    
    // MARK: Actions
    
}
