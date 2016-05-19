//
//  Tag.swift
//  Netwerk
//
//  Created by Juliana Cook on 5/17/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import Foundation

class Tag: PFObject, PFSubclassing {
    @NSManaged var user: PFUser
    @NSManaged var tagText: String?
    
    init( user: PFUser, tagText: String?) {
        super.init()
        
        self.user = user
        self.tagText = tagText
    }
    
    override init() {
        super.init()
    }
    
    static func parseClassName() -> String {
        return Tags.TagClass
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Tag.parseClassName())
        query.includeKey("user")
        query.orderByAscending("createdAt")
        return query
    }
    
}