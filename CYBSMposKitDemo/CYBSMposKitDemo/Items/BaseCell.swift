//
//  BaseCell.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 13/11/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import Foundation

@objc protocol ItemCellProtocol {
    
    @objc optional func tappedAdd(iCell: Any)
    @objc optional func textFieldDidEndEditing(textField: UITextField, forCell: Any)
    @objc optional func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool
}

class BaseCell : UITableViewCell, UITextFieldDelegate {
    weak var delegate:ItemCellProtocol?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing?(textField: textField, forCell: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (self.delegate?.textField?(textField: textField, shouldChangeCharactersInRange: range, replacementString: string))!
    }
}
