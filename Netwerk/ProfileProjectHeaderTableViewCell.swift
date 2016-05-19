//
//  ProfileProjectHeaderTableViewCell.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 5/18/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

protocol ProfileProjectHeaderTableViewCellDelegate {
    func didSelectProfileProjectHeaderTableViewCell(Selected: Bool, ProfileProjectHeader: ProfileProjectHeaderTableViewCell)
}

class ProfileProjectHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectHeaderButton: UIButton!
    
    var delegate : ProfileProjectHeaderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func selectedHeader(sender: AnyObject) {
        delegate?.didSelectProfileProjectHeaderTableViewCell(true, ProfileProjectHeader: self)
    }
}
