//
//  DetailCell.swift
//  CYBSMposKitDemo
//
//  Created by Li, Zezhong on 6/14/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
