//
//  PlaceOrderView.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 8/16/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class PlaceOrderView: UIView, UIKeyInput, UITextFieldDelegate {
    
    @IBOutlet weak var integerLabel: UILabel!
    @IBOutlet weak var decimalLabel: UILabel!
    @IBOutlet weak var payByCardReaderButton: UIButton!
    @IBOutlet weak var payByKeyedInButton: UIButton!
    @IBOutlet weak var payByManualButton: UIButton!
    @IBOutlet weak var payBySwipeButton: UIButton!
    @IBOutlet weak var bluetoothBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var resultTableView: UITableView!
    
    @objc var keyboardType: UIKeyboardType = .decimalPad
    
    var isKeyboardShown = false
    var hasDecimal = false
    var decimalSize = 0
    
    // MARK: - UIView
    
    override var canBecomeFirstResponder : Bool {
        return !isKeyboardShown
    }
    
    // MARK: - UIKeyInput
    
    var hasText : Bool {
        return true
    }
    
    func insertText(_ text: String) {
        return
        if hasDecimal {
            if decimalSize < 2 {
                let str = decimalLabel.text!.replacingCharacters(
                    in: decimalLabel.text!.characters.index(decimalLabel.text!.startIndex, offsetBy: decimalSize)..<decimalLabel.text!.characters.index(decimalLabel.text!.startIndex, offsetBy: decimalSize + 1),
                    with: text)
                let attributed = NSMutableAttributedString(string: str)
                attributed.addAttribute(NSForegroundColorAttributeName,
                                        value: UIColor.black,
                                        range: NSRange(location: 0, length: decimalSize + 1))
                attributed.addAttribute(NSForegroundColorAttributeName,
                                        value: UIColor.lightGray,
                                        range: NSRange(location: decimalSize + 1, length: 2 - decimalSize - 1))
                decimalLabel.attributedText = attributed
                decimalSize += 1
            }
        } else if text == "." {
            integerLabel.textColor = UIColor.black
            decimalLabel.textColor = UIColor.lightGray
            hasDecimal = true
        } else if integerLabel.text == "0" {
            integerLabel.text = text
            integerLabel.textColor = UIColor.black
        } else {
            integerLabel.text = (integerLabel.text ?? "") + text
        }
        
        let amount = NSDecimalNumber(string: "\(integerLabel.text!).\(decimalLabel.text!)")
        
        if amount.doubleValue > 0 {
            payByCardReaderButton.isEnabled = true
            payByKeyedInButton.isEnabled = true
            payByManualButton.isEnabled = true
            //payByTapButton.isEnabled = true
            payBySwipeButton.isEnabled = true
        }
    }
    
    func deleteBackward() {
        return
        if hasDecimal {
            decimalSize -= 1
            let str = decimalLabel.text!.replacingCharacters(
                in: decimalLabel.text!.characters.index(decimalLabel.text!.startIndex, offsetBy: decimalSize)..<decimalLabel.text!.characters.index(decimalLabel.text!.startIndex, offsetBy: decimalSize + 1),
                with: "0")
            let attributed = NSMutableAttributedString(string: str)
            attributed.addAttribute(NSForegroundColorAttributeName,
                                    value: UIColor.black,
                                    range: NSRange(location: 0, length: decimalSize))
            attributed.addAttribute(NSForegroundColorAttributeName,
                                    value: UIColor.lightGray,
                                    range: NSRange(location: decimalSize, length: 2 - decimalSize))
            decimalLabel.attributedText = attributed
            if decimalSize <= 0 {
                decimalLabel.textColor = UIColor.white
                hasDecimal = false
            }
        } else if !integerLabel.text!.isEmpty {
            var text = integerLabel.text![integerLabel.text!.startIndex..<integerLabel.text!.characters.index(before: integerLabel.text!.endIndex)]
            if text.isEmpty {
                text = "0"
                integerLabel.textColor = UIColor.lightGray
            }
            integerLabel.text = text
        }
        
        let amount = NSDecimalNumber(string: "\(integerLabel.text!).\(decimalLabel.text!)")
        
        if amount.doubleValue == 0 {
            payByCardReaderButton.isEnabled = false
            payByKeyedInButton.isEnabled = false
            payByManualButton.isEnabled = false
            //payByTapButton.isEnabled = false
            payBySwipeButton.isEnabled = false
        }
    }
    
}
