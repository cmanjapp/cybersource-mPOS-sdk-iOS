//
//  CYBSDropDown+Appearance.swift
//  CYBSMposKitDemo
//
//  Created by Rakesh Ramamurthy on 11/02/19.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import UIKit

extension CYBSDropDown {

	public class func setupDefaultAppearance() {
		let appearance = CYBSDropDown.appearance()

		appearance.cellHeight = CYBSDropDownConstants.UI.RowHeight
		appearance.backgroundColor = CYBSDropDownConstants.UI.BackgroundColor
		appearance.selectionBackgroundColor = CYBSDropDownConstants.UI.SelectionBackgroundColor
		appearance.separatorColor = CYBSDropDownConstants.UI.SeparatorColor
		appearance.cornerRadius = CYBSDropDownConstants.UI.CornerRadius
		appearance.shadowColor = CYBSDropDownConstants.UI.Shadow.Color
		appearance.shadowOffset = CYBSDropDownConstants.UI.Shadow.Offset
		appearance.shadowOpacity = CYBSDropDownConstants.UI.Shadow.Opacity
		appearance.shadowRadius = CYBSDropDownConstants.UI.Shadow.Radius
		appearance.animationduration = CYBSDropDownConstants.Animation.Duration
		appearance.textColor = CYBSDropDownConstants.UI.TextColor
        appearance.selectedTextColor = CYBSDropDownConstants.UI.SelectedTextColor
		appearance.textFont = CYBSDropDownConstants.UI.TextFont
	}

}
