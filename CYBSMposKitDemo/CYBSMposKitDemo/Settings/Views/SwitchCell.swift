//
//  SwitchCell.swift
//  CYBSMposKitDemo
//
//  Created by Li, Zezhong on 6/14/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet weak var titileLabel: UILabel!
    
    @IBAction func switchValueChange(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
