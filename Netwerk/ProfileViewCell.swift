//
//  ProfileViewCell.swift
//  Netwerk
//
//  Created by Megan Faulk on 5/4/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {


    
    @IBOutlet weak var kakPostLabel: UILabel!
    @IBOutlet weak var kakImageView: UIImageView!
    
    var kak: Kak? {
        didSet {
            updateUI();
        }
    }
    
    private func updateUI() {
        kakPostLabel?.attributedText = nil
        
        if let kak = self.kak {
            downloadImage(kak.videoURL, toImageView: kakImageView)
            kakPostLabel.text = kak.text
        }
    }
    
    private func downloadImage(url: NSURL, toImageView imageView: UIImageView){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    private func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error) }.resume()
    }
}
