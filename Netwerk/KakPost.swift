//
//  KakPost.swift
//  Netwerk
//
//  Created by Juliana Cook on 5/5/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//  From Parse Tutorial @ https://www.raywenderlich.com/98831/parse-tutorial-getting-started-web-backends
//

import Foundation

class KakPost: PFObject, PFSubclassing {
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
        return "KakPost"
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: KakPost.parseClassName())
        query.includeKey("user")
        query.orderByDescending("createdAt")
        return query
    }
    
}