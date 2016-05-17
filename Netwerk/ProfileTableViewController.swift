//
//  ProfileTableViewController.swift
//  Netwerk
//
//  Created by Megan Faulk on 5/16/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: Properties
    var posts: NSArray = [
        
        ["user": "Juliana Cook", "text": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/KfKt6R"],
        ["user": "Juliana Cook", "text": "so close", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/660Kug"],
        
        
        
        ["user": "Juliana Cook", "text": "Machining in the PRL for daysss", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/NMJVzk"],
        
        
        ["user": "Juliana Cook", "text": "First music box prototype!", "created_at":"12/25/2016", "id_str":"0003", "image_url":"https://scontent.xx.fbcdn.net/v/t1.0-9/12321288_10153274616332215_1359127258490569704_n.jpg?oh=1a384987e0149b70a84900953f163429&oe=579CFDB1", "video_url":"https://goo.gl/lZeoQf"],
        ]
    
    var kaks = Array<Kak>() {
        didSet {
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
    }
    
    
    private struct Storyboard {
        static let kakCellIdentifier = "userKak"
    }
    
    
    // MARK: - Table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kaks.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.kakCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = posts[indexPath.item] as? String
        
        let kak = kaks[indexPath.section]
        
        if let kakCell = cell as? ProfileViewCell {
            kakCell.kak = kak;
        }
        
        return cell
    }

}
