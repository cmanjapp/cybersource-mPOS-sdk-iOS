//
//  SettingsTableViewController.swift
//  CYBSMposKitDemo
//
//  Created by Sun, Michael on 7/6/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    let sections = ["Account", "Endpoints", "Generating Access Token", "POS", "EntryType", "Partial auth", "Commerce Indicator", "Tokenization", "Signature", "Merchant Defined Data", "UI Settings", "About", "Currency"]
    #if DEBUG
    let numberOfRowsInSection = [8, 8, 3, 3, 2, 1, 4, 1, 1, 5, 19, 2, 1]
    #else
    let numberOfRowsInSection = [8, 7, 3, 3, 2, 1, 4, 1, 1, 5, 19, 2, 1]
    #endif
    
    let generatingAccessTokenMethods = ["Use Client Credentials", "Use Username and Password", "Manual"]
    let readerTypes = ["Swipe", "Swipe or Insert"]
    //let commereceIndicators = ["Ecom", "Retail point of sale"]
    let commereceIndicators = ["Internet", "Retail", "Recurring", "MOTO"]

    var pendingTextField: UITextField? = nil
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        
        // make the keyboard disappear when tapping background
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(SettingsTableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - IBAction
    
    @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
        if let indexPath = getSenderIndexPath(sender) {
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    if let control = sender as? UISegmentedControl {
                        if let textField = pendingTextField {
                            updateSetting(textField)
                        }
                        Settings.setEnvironment(control.selectedSegmentIndex)
                        Settings.sharedInstance.reload()
                        tableView.reloadData()
                    }
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    #if DEBUG
    @IBAction func uiSwitchValueChanged(_ sender: UISwitch) {
        if let indexPath = getSenderIndexPath(sender) {
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 7:
                    Settings.sharedInstance.trustServerCertificate = sender.isOn
                    Settings.sharedInstance.save()
                default:
                    break
                }
            default:
                break
            }
        }
    }
    #endif
    
    @IBAction func tokenizationSwitchValueChanged(_ sender: UISwitch) {
        if let indexPath = getSenderIndexPath(sender) {
            switch indexPath.section {
            case 6:
                switch indexPath.row {
                case 0:
                    Settings.sharedInstance.enableTokenization = sender.isOn
                    Settings.sharedInstance.save()
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    
    @IBAction func resetAllSettings(_ sender: AnyObject) {
        Utils.resetSettings()
        Settings.sharedInstance.reload()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 12 {
            return tableView.dequeueReusableCell(withIdentifier: "ResetTableViewCell", for: indexPath)
        }
        
        let cell = getSettingsTableViewCell(tableView, forIndexPath: indexPath)
        switch (indexPath as NSIndexPath).section {
        case 0:
            switch (indexPath as NSIndexPath).row {
            case 0:
                buildOptions(cell, label: "Environment", options: Settings.environments, selected: Settings.getEnvironment())
            case 1:
                buildTextField(cell, label: "Merchant ID", value: Settings.sharedInstance.merchantID, secureTextEntry: false)
            case 2:
                buildTextField(cell, label: "Device ID", value: Settings.sharedInstance.deviceID, secureTextEntry: false)
            case 3:
                buildTextField(cell, label: "Client ID", value: Settings.sharedInstance.clientID, secureTextEntry: false)
            case 4:
                buildTextField(cell, label: "Client Secret", value: Settings.sharedInstance.clientSecret, secureTextEntry: true)
            case 5:
                buildTextField(cell, label: "Username", value: Settings.sharedInstance.username, secureTextEntry: false)
            case 6:
                buildTextField(cell, label: "Password", value: Settings.sharedInstance.password, secureTextEntry: true)
            case 7:
                buildTextField(cell, label: "Access Token", value: Settings.sharedInstance.accessToken, secureTextEntry: true)
            default:
                break
            }
        case 1:
            if Settings.getEnvironment() == 0 {
                switch (indexPath as NSIndexPath).row {
                case 0:
                    buildLabel(cell, label: "Simple Order", value: CYBSMposSettingsLiveSimpleOrderAPIURL)
                case 1:
                    buildLabel(cell, label: "Transaction Search", value: CYBSMposSettingsLiveTransactionSearchAPIURL)
                case 2:
                    buildLabel(cell, label: "Transaction Detail", value: CYBSMposSettingsLiveTransactionDetailAPIURL)
                case 3:
                    buildLabel(cell, label: "Receipt", value: CYBSMposSettingsLiveReceiptAPIURL)
                case 4:
                    buildLabel(cell, label: "Substitute Receipt", value: CYBSMposSettingsLiveSubstituteReceiptAPIURL)
                case 5:
                    buildLabel(cell, label: "OAuth Token", value: "https://auth.ic3.com/apiauth/v1/oauth/token")
                case 6:
                    buildTextField(cell, label: "Simple Order Ver", value: Settings.sharedInstance.simpleOrderAPIVersion, secureTextEntry: false)
                case 8:
                    buildLabel(cell, label: "Device Registration", value: CYBSMposSettingsLiveDeviceRegistrationAPIURL)
                default:
                    break
                }
                #if DEBUG
                    switch indexPath.row {
                    case 7:
                        buildUiSwitch(cell, label: "Trust Server Cert", on: Settings.sharedInstance.trustServerCertificate, enable: false)
                    default:
                        break
                    }
                #endif
            } else if Settings.getEnvironment() == 1 {
                switch (indexPath as NSIndexPath).row {
                case 0:
                    buildLabel(cell, label: "Simple Order", value: CYBSMposSettingsTestSimpleOrderAPIURL)
                case 1:
                    buildLabel(cell, label: "Transaction Search", value: CYBSMposSettingsTestTransactionSearchAPIURL)
                case 2:
                    buildLabel(cell, label: "Transaction Detail", value: CYBSMposSettingsTestTransactionDetailAPIURL)
                case 3:
                    buildLabel(cell, label: "Receipt", value: CYBSMposSettingsTestReceiptAPIURL)
                case 4:
                    buildLabel(cell, label: "Substitute Receipt", value: CYBSMposSettingsTestSubstituteReceiptAPIURL)
                case 5:
                    buildLabel(cell, label: "OAuth Token", value: "https://authtest.ic3.com/apiauth/v1/oauth/token")
                case 6:
                    buildTextField(cell, label: "Simple Order Ver", value: Settings.sharedInstance.simpleOrderAPIVersion, secureTextEntry: false)
                case 8:
                    buildLabel(cell, label: "Device Registration", value: CYBSMposSettingsTestDeviceRegistrationAPIURL)
                default:
                    break
                }
                #if DEBUG
                    switch indexPath.row {
                    case 7:
                        buildUiSwitch(cell, label: "Trust Server Cert", on: Settings.sharedInstance.trustServerCertificate, enable: false)
                    default:
                        break
                    }
                #endif
            } else {
                #if DEBUG
                    switch indexPath.row {
                    case 0:
                        buildTextField(cell, label: "Simple Order", value: Settings.sharedInstance.customSimpleOrderAPIURL, secureTextEntry: false)
                    case 1:
                        buildTextField(cell, label: "Transaction Search", value: Settings.sharedInstance.customTransactionSearchAPIURL, secureTextEntry: false)
                    case 2:
                        buildTextField(cell, label: "Transaction Detail", value: Settings.sharedInstance.customTransactionDetailAPIURL, secureTextEntry: false)
                    case 3:
                        buildTextField(cell, label: "Receipt", value: Settings.sharedInstance.customReceiptAPIURL, secureTextEntry: false)
                    case 4:
                        buildTextField(cell, label: "Substitute Receipt", value: Settings.sharedInstance.customSubstituteReceiptAPIURL, secureTextEntry: false)
                    case 5:
                        buildTextField(cell, label: "OAuth Token", value: Settings.sharedInstance.customOAuthTokenAPIURL, secureTextEntry: false)
                    case 6:
                        buildTextField(cell, label: "Simple Order Ver", value: Settings.sharedInstance.simpleOrderAPIVersion, secureTextEntry: false)
                    case 7:
                        buildUiSwitch(cell, label: "Trust Server Cert", on: Settings.sharedInstance.trustServerCertificate, enable: true)
                    case 8:
                        buildTextField(cell, label: "Device Registration", value: Settings.sharedInstance.customDeviceRegistrationAPIURL, secureTextEntry: false)
                    default:
                        break
                    }
                #endif
            }
        case 2:
            cell.label.text = generatingAccessTokenMethods[(indexPath as NSIndexPath).row];
            if Settings.sharedInstance.generatingAccessTokenMethod == (indexPath as NSIndexPath).row {
                cell.accessoryType = .checkmark
            }
        case 3:
            switch (indexPath as NSIndexPath).row {
            case 0:
                buildTextField(cell, label: "Terminal ID", value: Settings.sharedInstance.terminalID, secureTextEntry: false)
            case 1:
                buildTextField(cell, label: "Alternate ID", value: Settings.sharedInstance.terminalIDAlternate, secureTextEntry: false)
            case 2:
                buildTextField(cell, label: "MID", value: Settings.sharedInstance.mid, secureTextEntry: false)
            default:
                break
            }
        case 4:
            cell.label.text = readerTypes[(indexPath as NSIndexPath).row];
            if Settings.sharedInstance.readerType == (indexPath as NSIndexPath).row {
                cell.accessoryType = .checkmark
            }
        case 5:
            cell.label.text = commereceIndicators[(indexPath as NSIndexPath).row];
            if Settings.sharedInstance.commereceIndicator == (indexPath as NSIndexPath).row {
                cell.accessoryType = .checkmark
            }
        case 6:
            switch (indexPath as NSIndexPath).row {
            case 0:
            buildTokenizationUiSwitch(cell, label: "Enable Tokenization", on: Settings.sharedInstance.enableTokenization, enable: true)
            default:
                break
            }
        case 7:
            switch (indexPath as NSIndexPath).row {
            case 0:
                buildTextField(cell, label: "Enter min. amount", value: "\(Settings.sharedInstance.signatureMinAmount)", secureTextEntry: false)
            default:
                break
            }
        case 8:
            switch (indexPath as NSIndexPath).row {
            case 0:
                buildTextField(cell, label: "Field 1", value: Settings.sharedInstance.mddField1, secureTextEntry: false)
            case 1:
                buildTextField(cell, label: "Field 2", value: Settings.sharedInstance.mddField2, secureTextEntry: false)
            case 2:
                buildTextField(cell, label: "Field 3", value: Settings.sharedInstance.mddField3, secureTextEntry: false)
            case 3:
                buildTextField(cell, label: "Field 4", value: Settings.sharedInstance.mddField4, secureTextEntry: false)
            case 4:
                buildTextField(cell, label: "Field 5", value: Settings.sharedInstance.mddField5, secureTextEntry: false)
            default:
                break
            }
        case 9:
            switch (indexPath as NSIndexPath).row {
            case 0:
                buildTextField(cell, label: "Top Image URL", value: Settings.sharedInstance.topImageURL, secureTextEntry: false)
            case 1:
                buildTextField(cell, label: "Background Color", value: Settings.sharedInstance.backgroundColor, secureTextEntry: false)
            case 2:
                buildTextField(cell, label: "Spinner Color", value: Settings.sharedInstance.spinnerColor, secureTextEntry: false)
            case 3:
                buildTextField(cell, label: "Text Label Color", value: Settings.sharedInstance.textLabelColor, secureTextEntry: false)
            case 4:
                buildTextField(cell, label: "Detail Label Color", value: Settings.sharedInstance.detailLabelColor, secureTextEntry: false)
            case 5:
                buildTextField(cell, label: "Text Field Color", value: Settings.sharedInstance.textFieldColor, secureTextEntry: false)
            case 6:
                buildTextField(cell, label: "Placeholder Color", value: Settings.sharedInstance.placeholderColor, secureTextEntry: false)
            case 7:
                buildTextField(cell, label: "Signature Color", value: Settings.sharedInstance.signatureColor, secureTextEntry: false)
            case 8:
                buildTextField(cell, label: "Signature Bg Color", value: Settings.sharedInstance.signatureBackgroundColor, secureTextEntry: false)
            case 9:
                buildTextField(cell, label: "Tint Color", value: Settings.sharedInstance.tintColor, secureTextEntry: false)
            case 10:
                buildTextField(cell, label: "Ultra Light Font", value: Settings.sharedInstance.ultraLightFont, secureTextEntry: false)
            case 11:
                buildTextField(cell, label: "Thin Font", value: Settings.sharedInstance.thinFont, secureTextEntry: false)
            case 12:
                buildTextField(cell, label: "Light Font", value: Settings.sharedInstance.lightFont, secureTextEntry: false)
            case 13:
                buildTextField(cell, label: "Regular Font", value: Settings.sharedInstance.regularFont, secureTextEntry: false)
            case 14:
                buildTextField(cell, label: "Medium Font", value: Settings.sharedInstance.mediumFont, secureTextEntry: false)
            case 15:
                buildTextField(cell, label: "Semibold Font", value: Settings.sharedInstance.semiboldFont, secureTextEntry: false)
            case 16:
                buildTextField(cell, label: "Bold Font", value: Settings.sharedInstance.boldFont, secureTextEntry: false)
            case 17:
                buildTextField(cell, label: "Heavy Font", value: Settings.sharedInstance.heavyFont, secureTextEntry: false)
            case 18:
                buildTextField(cell, label: "Black Font", value: Settings.sharedInstance.blackFont, secureTextEntry: false)
            default:
                break
            }
        case 10:
            switch (indexPath as NSIndexPath).row {
            case 0:
                buildLabel(cell, label: "App Version", value: getVersion())
            case 1:
                buildLabel(cell, label: "Build Version", value: getBuild())
            default:
                break
            }
        case 11:
            switch (indexPath as NSIndexPath).row {
            case 0:
                print("++++++++++++++++++++++++++++++++++")
                buildTextField(cell, label: "Currency", value: Settings.sharedInstance.currency, secureTextEntry: false)
                print("Currency: %@", Settings.sharedInstance.currency as Any)
                print("++++++++++++++++++++++++++++++++++")
                
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 2:
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            for row in 0...2 {
                if row != (indexPath as NSIndexPath).row {
                    tableView.cellForRow(at: IndexPath(row: row, section: 2))?.accessoryType = .none
                }
            }
            Settings.sharedInstance.generatingAccessTokenMethod = (indexPath as NSIndexPath).row
            Settings.sharedInstance.save()
        case 4:
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            for row in 0...1 {
                if row != (indexPath as NSIndexPath).row {
                    tableView.cellForRow(at: IndexPath(row: row, section: 4))?.accessoryType = .none
                }
            }
            Settings.sharedInstance.readerType = (indexPath as NSIndexPath).row
            Settings.sharedInstance.save()
        case 5:
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            for row in 0...1 {
                if row != (indexPath as NSIndexPath).row {
                    tableView.cellForRow(at: IndexPath(row: row, section: 5))?.accessoryType = .none
                }
            }
            Settings.sharedInstance.commereceIndicator = (indexPath as NSIndexPath).row
            Settings.sharedInstance.save()
        default:
            break
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pendingTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if pendingTextField != nil {
            updateSetting(textField)
        }
    }
    
    // MARK: -
    
    func buildLabel(_ cell: SettingsTableViewCell, label: String?, value: String?) {
        cell.label.text = label
        cell.valueLabel.text = value
        cell.valueLabel.isHidden = false
    }
    
    func buildOptions(_ cell: SettingsTableViewCell, label: String?, options: [String], selected: Int) {
        cell.label.text = label
        for (index, option) in options.enumerated() {
            cell.segmentedControl.insertSegment(withTitle: option, at: index, animated: false)
        }
        cell.segmentedControl.selectedSegmentIndex = selected
        cell.segmentedControl.isHidden = false
    }
    
    func buildTextField(_ cell: SettingsTableViewCell, label: String?, value: String?, secureTextEntry: Bool) {
        cell.label.text = label
        cell.textField.text = value
        cell.textField.isSecureTextEntry = secureTextEntry
        cell.textField.isHidden = false
        cell.textField.adjustsFontSizeToFitWidth = !secureTextEntry
    }
    
    func buildUiSwitch(_ cell: SettingsTableViewCell, label: String?, on: Bool, enable: Bool) {
        cell.label.text = label
        cell.uiSwitch.isOn = on
        cell.uiSwitch.isHidden = false
        cell.uiSwitch.isEnabled = enable
    }
    
    func buildTokenizationUiSwitch(_ cell: SettingsTableViewCell, label: String?, on: Bool, enable: Bool) {
        cell.label.text = label
        cell.tokenizationSwitch.isOn = on
        cell.tokenizationSwitch.isHidden = false
        cell.tokenizationSwitch.isEnabled = false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getBuild() -> String? {
        if let dictionary = Bundle.main.infoDictionary {
            if let build = dictionary["CFBundleVersion"] as? String {
                return build
            }
        }
        return nil
    }
    
    func getSenderIndexPath(_ sender: AnyObject) -> IndexPath? {
        if let view = sender as? UIView {
            let point = tableView.convert(CGPoint.zero, from: view)
            return tableView.indexPathForRow(at: point)
        }
        return nil
    }
    
    func getSettingsTableViewCell(_ tableView: UITableView, forIndexPath: IndexPath) -> SettingsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell",
                                                               for: forIndexPath) as! SettingsTableViewCell
        cell.accessoryType = .none
        cell.textField.isHidden = true
        cell.textField.delegate = self
        cell.segmentedControl.isHidden = true
        cell.segmentedControl.removeAllSegments()
        cell.valueLabel.isHidden = true
        cell.uiSwitch.isHidden = true
        cell.tokenizationSwitch.isHidden = true
        return cell
    }
    
    func getVersion() -> String? {
        if let dictionary = Bundle.main.infoDictionary {
            if let version = dictionary["CFBundleShortVersionString"] as? String {
                return version
            }
        }
        return nil
    }
    
    func updateSetting(_ textField: UITextField) {
        pendingTextField = nil
        if let text = textField.text {
            if let indexPath = getSenderIndexPath(textField) {
                switch (indexPath as NSIndexPath).section {
                case 0:
                    switch (indexPath as NSIndexPath).row {
                    case 1:
                        Settings.sharedInstance.merchantID = text
                    case 2:
                        Settings.sharedInstance.deviceID = text
                    case 3:
                        Settings.sharedInstance.clientID = text
                    case 4:
                        Settings.sharedInstance.clientSecret = text
                    case 5:
                        Settings.sharedInstance.username = text
                    case 6:
                        Settings.sharedInstance.password = text
                    case 7:
                        Settings.sharedInstance.accessToken = text
                    default:
                        break
                    }
                case 1:
                    if (indexPath as NSIndexPath).row == 6 {
                        Settings.sharedInstance.simpleOrderAPIVersion = text
                    }
                    #if DEBUG
                        if Settings.getEnvironment() == 2 {
                            switch indexPath.row {
                            case 0:
                                Settings.sharedInstance.customSimpleOrderAPIURL = text
                            case 1:
                                Settings.sharedInstance.customTransactionSearchAPIURL = text
                            case 2:
                                Settings.sharedInstance.customTransactionDetailAPIURL = text
                            case 3:
                                Settings.sharedInstance.customReceiptAPIURL = text
                            case 4:
                                Settings.sharedInstance.customSubstituteReceiptAPIURL = text
                            case 5:
                                Settings.sharedInstance.customOAuthTokenAPIURL = text
                            case 6:
                                Settings.sharedInstance.simpleOrderAPIVersion = text
                            case 8:
                                Settings.sharedInstance.customDeviceRegistrationAPIURL = text
                            default:
                                break
                            }
                        }
                    #else
                        break
                    #endif
                case 3:
                    switch (indexPath as NSIndexPath).row {
                    case 0:
                        Settings.sharedInstance.terminalID = text
                    case 1:
                        Settings.sharedInstance.terminalIDAlternate = text
                    case 2:
                        Settings.sharedInstance.mid = text
                    default:
                        break
                    }
                case 7:
                        Settings.sharedInstance.signatureMinAmount = Float(textField.text!)!
                case 8:
                    switch (indexPath as NSIndexPath).row {
                    case 0:
                        Settings.sharedInstance.mddField1 = text
                    case 1:
                        Settings.sharedInstance.mddField2 = text
                    case 2:
                        Settings.sharedInstance.mddField3 = text
                    case 3:
                        Settings.sharedInstance.mddField4 = text
                    case 4:
                        Settings.sharedInstance.mddField5 = text
                    default:
                        break
                    }
                case 9:
                    switch (indexPath as NSIndexPath).row {
                    case 0:
                        Settings.sharedInstance.topImageURL = text
                    case 1:
                        Settings.sharedInstance.backgroundColor = text
                    case 2:
                        Settings.sharedInstance.spinnerColor = text
                    case 3:
                        Settings.sharedInstance.textLabelColor = text
                    case 4:
                        Settings.sharedInstance.detailLabelColor = text
                    case 5:
                        Settings.sharedInstance.textFieldColor = text
                    case 6:
                        Settings.sharedInstance.placeholderColor = text
                    case 7:
                        Settings.sharedInstance.signatureColor = text
                    case 8:
                        Settings.sharedInstance.signatureBackgroundColor = text
                    case 9:
                        Settings.sharedInstance.tintColor = text
                    case 10:
                        Settings.sharedInstance.ultraLightFont = text
                    case 11:
                        Settings.sharedInstance.thinFont = text
                    case 12:
                        Settings.sharedInstance.lightFont = text
                    case 13:
                        Settings.sharedInstance.regularFont = text
                    case 14:
                        Settings.sharedInstance.mediumFont = text
                    case 15:
                        Settings.sharedInstance.semiboldFont = text
                    case 16:
                        Settings.sharedInstance.boldFont = text
                    case 17:
                        Settings.sharedInstance.heavyFont = text
                    case 18:
                        Settings.sharedInstance.blackFont = text
                    default:
                        break
                    }
                case 11:
                    switch (indexPath as NSIndexPath).row {
                    case 0:
                        Settings.sharedInstance.currency = text
                    default:
                        break
                    }
                default:
                    break
                }
                Settings.sharedInstance.save()
            }
        }
    }
    
}
