//
//  KakTableViewCell.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/26/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class KakTableViewCell: UITableViewCell, UIWebViewDelegate {


    @IBOutlet weak var kakScreenNameLabel: UILabel!

    @IBOutlet weak var kakPostLabel: UILabel!
    
    @IBOutlet weak var kakWebView: UIWebView!
    
    @IBOutlet weak var kakProfileImageView: UIImageView!
    
    
    
    var kak: Kak? {
        didSet {
            updateUI();
        }
    }
    
    private func updateUI() {
        kakPostLabel?.attributedText = nil
        kakScreenNameLabel?.text = nil
        
        if let kak = self.kak {
            kakPostLabel.text = kak.text
            
            kakScreenNameLabel?.text = kak.user
            downloadImage(kak.imageURL,
                          toImageView: kakProfileImageView)
            setProfileImageView(kakProfileImageView)
            
            // TODO: change to am image view
            let videoURLRequest : NSURLRequest = NSURLRequest(URL: kak.videoURL)
            kakWebView.delegate = self
            kakWebView.loadRequest(videoURLRequest)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // TODO: make this better
        let contentSize = webView.scrollView.contentSize
        let viewSize = webView.bounds.size
        
        let rw = viewSize.width / contentSize.width
        
        webView.scrollView.minimumZoomScale = rw
        webView.scrollView.maximumZoomScale = rw
        webView.scrollView.zoomScale = rw
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
}
