//
//  CYBSKeyboardListener.swift
//  CYBSMposKitDemo
//
//  Created by Rakesh Ramamurthy on 11/02/19.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import UIKit

internal final class CYBSKeyboardListener {
	
	static let sharedInstance = CYBSKeyboardListener()
	
	fileprivate(set) var isVisible = false
	fileprivate(set) var keyboardFrame = CGRect.zero
	fileprivate var isListening = false
	
	deinit {
		stopListeningToKeyboard()
	}
	
}

//MARK: - Notifications

extension CYBSKeyboardListener {
	
	func startListeningToKeyboard() {
		if isListening {
			return
		}
		
		isListening = true
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
			object: nil)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
			object: nil)
	}
	
	func stopListeningToKeyboard() {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc
	fileprivate func keyboardWillShow(_ notification: Notification) {
		isVisible = true
		keyboardFrame = keyboardFrame(fromNotification: notification)
	}
	
	@objc
	fileprivate func keyboardWillHide(_ notification: Notification) {
		isVisible = false
		keyboardFrame = keyboardFrame(fromNotification: notification)
	}
	
	fileprivate func keyboardFrame(fromNotification notification: Notification) -> CGRect {
        return ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
	}
	
}
