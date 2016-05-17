//
//  ProfileViewCell.swift
//  Netwerk
//
//  Created by Megan Faulk on 5/4/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class ProfileViewCell: PFTableViewCell {


    
    @IBOutlet weak var kakPostLabel: UILabel!
    @IBOutlet weak var kakImageView: PFImageView!
    
    var kak: Kak? {
        didSet {
            updateUI();
        }
    }
    
    private func updateUI() {
        kakPostLabel?.attributedText = nil
        
        if let kak = self.kak {
            kakPostLabel.text = kak.text
        }
    }
    
}
