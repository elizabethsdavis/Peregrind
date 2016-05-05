//
//  Kak.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/27/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

public class Kak: NSObject {
    
    public let text: String
    public let user: String
    public let created: String
    public let id: String
    public let imageURL: NSURL
    public let videoURL: NSURL
    
    init?(data: NSDictionary?)
    {
        guard
            
            let user = data?.valueForKeyPath(KakKey.User) as? String,
            let text = data?.valueForKeyPath(KakKey.Text) as? String,
            let created = (data?.valueForKeyPath(KakKey.Created) as? String),
            let id = data?.valueForKeyPath(KakKey.ID) as? String,
            let imageURLString = data?.valueForKeyPath(KakKey.ImageURL) as? String,
            let videoURLString = data?.valueForKeyPath(KakKey.VideoURL) as? String
            
            else {
                return nil
            }
        
        self.user = user
        self.text = text
        self.created = created
        self.id = id
        self.imageURL = NSURL(string: imageURLString)!
        self.videoURL = NSURL(string: videoURLString)!
 
    }
    
    struct KakKey {
        static let User = "user"
        static let Text = "text"
        static let Created = "created_at"
        static let ID = "id_str"
        static let ImageURL = "image_url"
        static let VideoURL = "video_url"
    }
}
