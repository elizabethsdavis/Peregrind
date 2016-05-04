//
//  WallPost.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/8/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//  From Parse Tutorial @ https://www.raywenderlich.com/98831/parse-tutorial-getting-started-web-backends

import Foundation
import Parse

class WallPost: PFObject, PFSubclassing {
    @NSManaged var image: PFFile
    @NSManaged var user: PFUser
    @NSManaged var comment: String?
    
    init(image: PFFile, user: PFUser, comment: String?) {
        super.init()
        
        self.image = image
        self.user = user
        self.comment = comment
    }
    
    override init() {
        super.init()
    }
    
    static func parseClassName() -> String {
        // TODO: rename something reasonable!
        return "Armor"
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: WallPost.parseClassName())
        query.includeKey("user")
        query.orderByDescending("createdAt")
        return query
    }
    
}
