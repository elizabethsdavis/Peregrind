//
//  KakTableViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/25/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class KakTableViewController: UITableViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
 
    
    var posts: NSArray = [
        
        ["user": "Elizabeth Davis", "text": "I absolutely love to learn!!!", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url":"https://www.youtube.com/embed/lMAISeUGcyY"],
        
        ["user": "Samuel Hinshelwood", "text": "Learning is everything <3", "created_at":"04/05/2016", "id_str":"0002", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/10649571_10206228274366972_5329742365679361816_n.jpg?oh=3f65c56edc39b7cebbaefa7a3ab585aa&oe=579E333D", "video_url":"https://www.youtube.com/embed/YGV6NkKDJ4o"],
        
        ["user": "Julien Brinson", "text": "I like learning a lot :)", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/v/t1.0-9/19181_10202609887128470_9124914537994045659_n.jpg?oh=40b5d4c1e86bf4a37b5843b964ceb328&oe=57BC9A1D", "video_url":"https://www.youtube.com/embed/3q8tkoqdAlU"],
        
        ["user": "Elizabeth Davis", "text": "I absolutely love to learn!!!", "created_at":"03/04/2016", "id_str":"0001", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/s960x960/12605370_1408376795859140_1184442056620693026_o.jpg", "video_url":"https://www.youtube.com/embed/lMAISeUGcyY"],
        
        ["user": "Samuel Hinshelwood", "text": "Learning is everything <3", "created_at":"04/05/2016", "id_str":"0002", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/10649571_10206228274366972_5329742365679361816_n.jpg?oh=3f65c56edc39b7cebbaefa7a3ab585aa&oe=579E333D", "video_url":"https://www.youtube.com/embed/YGV6NkKDJ4o"],
        
        ["user": "Julien Brinson", "text": "I like learning a lot :)", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent-sjc2-1.xx.fbcdn.net/v/t1.0-9/19181_10202609887128470_9124914537994045659_n.jpg?oh=40b5d4c1e86bf4a37b5843b964ceb328&oe=57BC9A1D", "video_url":"https://www.youtube.com/embed/3q8tkoqdAlU"],
    ]
    
    var kaks = [Array<Kak>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func loadKaks() {
        var kakPost = [Kak]()
        for i in 1...posts.count {
            if let kak = Kak(data: posts[i-1] as? NSDictionary) {
                kakPost.append(kak)
            }
            
        }
        kaks.append(kakPost)
    }

   
    var searchText: String? {
        didSet {
            title = searchText
            loadKaks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKaks()
//        searchText = "#learning"

    }

    private struct Storyboard {
        static let kakCellIdentifier = "Kak"
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kaks.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kaks[section].count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.kakCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = posts[indexPath.item] as? String
       
        // Configure the cell...
        let kak = kaks[indexPath.section][indexPath.row]
        
        if let kakCell = cell as? KakTableViewCell {
            kakCell.kak = kak
        }
       
        return cell
    }
    
    // In this case I returning 140.0. You can change this value depending of your cell
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300.0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, 120))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
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
