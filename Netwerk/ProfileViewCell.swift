//
//  ProfileViewCell.swift
//  Netwerk
//
//  Created by Megan Faulk on 5/4/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell, UIWebViewDelegate {


    @IBOutlet weak var kakPostLabel: UILabel!
    
    @IBOutlet weak var kakWebView: UIWebView!
    
    var kak: Kak? {
        didSet {
            updateUI();
        }
    }
    
    private func updateUI() {
        kakPostLabel?.attributedText = nil
        
        if let kak = self.kak {
            kakPostLabel.text = kak.text
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
}
