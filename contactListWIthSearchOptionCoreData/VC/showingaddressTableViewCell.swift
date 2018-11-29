//
//  showingaddressTableViewCell.swift
//  contactListWIthSearchOptionCoreData
//
//   Created by Sds mac mini on 26/11/18.
//  Copyright © 2018 straightdrive.co.in. All rights reserved.
//

import UIKit

class showingaddressTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!{
        didSet {

            profileImg.layer.borderWidth = 1.0
            profileImg.layer.masksToBounds = false
            profileImg.layer.borderColor = UIColor.black.cgColor
            profileImg.layer.cornerRadius = profileImg.frame.height/2
            profileImg.clipsToBounds = true
        }
    }
    @IBOutlet weak var profileName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
