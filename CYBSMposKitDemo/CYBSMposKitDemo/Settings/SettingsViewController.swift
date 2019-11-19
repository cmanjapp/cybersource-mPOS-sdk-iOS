//
//  SettingsViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 6/14/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import UIKit

public struct StoreAttribute {
    var storeName: String
    var merchantId: String
    var deviceId: String
    var clientId: String
    var terminalId: String
}

class SettingsViewController: UITableViewController {
    enum Section : Int {
        case Environment = 0
        case DecryptionServices
        case Account
        case GeneratingAccessToken
        case Pos
        case SupportedServices
        case PartialAuthIndicator
        case commerceIndicator
        case signature
        case Taxes
        case Tips
        case merchantDefinedData
        case uISettings
        case Endpoints
        case Currency
        case OTA
        case Address
        case resetAllSettings
        case about
    }
    
    enum AboutSection : Int {
        case PrivacyPolicy = 0
        case HelpFeedback
    }
    
    @IBOutlet weak var environmentSegment: UISegmentedControl!
    
    // Account Section
    @IBOutlet weak var merchantIdField: UITextField!
    @IBOutlet weak var deviceIdField: UITextField!
    @IBOutlet weak var clientIdField: UITextField!
    @IBOutlet weak var clientSecretField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var accessTokenField: UITextField!
    
    @IBOutlet weak var storeNameField: UITextField!
    @IBOutlet weak var storeIdChooseBtn: UIButton!

    // Endpoints Section
    @IBOutlet weak var simpleOrderField: UITextField!
    @IBOutlet weak var transactionSearchField: UITextField!
    @IBOutlet weak var transactionDetailField: UITextField!
    @IBOutlet weak var receiptField: UITextField!
    @IBOutlet weak var substituteReceiptField: UITextField!
    @IBOutlet weak var oAuthTokenField: UITextField!
    @IBOutlet weak var deviceRegistrationField: UITextField!
    @IBOutlet weak var simpleOrderVerField: UITextField!
    @IBOutlet weak var trustServerCertSwitch: UISwitch!
    @IBOutlet weak var maskSwitch: UISwitch!
    @IBOutlet weak var taxField: UITextField!

    
    var simpleOrderFieldValue:String?
    var transactionSearchFieldValue:String?
    var transactionDetailFieldValue:String?
    var receiptFieldValue:String?
    var substituteReceiptFieldValue:String?
    var deviceRegistrationFieldValue:String?
    var oAuthTokenFieldValue:String?
    var simpleOrderVerFieldValue:String?

    // POS Section
    @IBOutlet weak var terminalIdField: UITextField!
    @IBOutlet weak var alternateIdField: UITextField!
    @IBOutlet weak var mIdField: UITextField!
    
    // Signature Section
    @IBOutlet weak var minAmountField: UITextField!
    
    // Merchant Defined Data
    @IBOutlet weak var mDdField1: UITextField!
    @IBOutlet weak var mDdField2: UITextField!
    @IBOutlet weak var mDdField3: UITextField!
    @IBOutlet weak var mDdField4: UITextField!
    @IBOutlet weak var mDdField5: UITextField!
    @IBOutlet weak var merchantTransactionIdentifier: UITextField!
    
    // UI Settings Section
    @IBOutlet weak var topImageUrlField: UITextField!
    @IBOutlet weak var backgroundColorField: UITextField!
    @IBOutlet weak var spinnerColorField: UITextField!
    @IBOutlet weak var TextLabelColorField: UITextField!
    @IBOutlet weak var detailLabelColorField: UITextField!
    @IBOutlet weak var textFieldColorField: UITextField!
    @IBOutlet weak var placeholderColorField: UITextField!
    @IBOutlet weak var signatureColorField: UITextField!
    @IBOutlet weak var signatureBgColorField: UITextField!
    @IBOutlet weak var tintColorField: UITextField!
    @IBOutlet weak var ultraLightFontField: UITextField!
    @IBOutlet weak var thinFontField: UITextField!
    @IBOutlet weak var lightFontField: UITextField!
    @IBOutlet weak var regularFontField: UITextField!
    @IBOutlet weak var mediumFontField: UITextField!
    @IBOutlet weak var semiboldFontField: UITextField!
    @IBOutlet weak var boldFontField: UITextField!
    @IBOutlet weak var heavyFontField: UITextField!
    @IBOutlet weak var blackFontField: UITextField!
    @IBOutlet weak var showReceiptSwitch: UISwitch!
    @IBOutlet weak var currencyField: UITextField!
    @IBOutlet weak var partialAuthSwitch: UISwitch!
    @IBOutlet weak var tipsSwitch: UISwitch!
    @IBOutlet weak var signatureSwitch: UISwitch!
    @IBOutlet weak var taxSwitch: UISwitch!

    // UI components -> UISettings mapping
    fileprivate var mapping = [Int : String]()
    
    let chooseStoreDropDown = CYBSDropDown()
    var storesDataLIVE = Array<StoreAttribute> ()
    var storesDataCAS = Array<StoreAttribute> ()
    var storesDataCUSTOM = Array<StoreAttribute> ()
    
    // MARK: - Settings view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        readStoreInfo()

        setLogoForTitle()
        setVersions()
        setKeyboardTapDismiss()
        setEnvironmentSegment()
        self.maskSwitch.setOn(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readStoreInfo()
        updateAllSettings()

        //this is required to show updated merchantTransactionIdentifier value after transaction
        updateMerchantDefinedData()
        setupStoresDropDown()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // save is called when leaving the view & change environment
        Settings.sharedInstance.save()
    }
    
    // MARK: - UI Setting for current view
    
    private func setEnvironmentSegment() {
        environmentSegment.removeSegment(at: 2, animated: false)
        environmentSegment.selectedSegmentIndex = Settings.getEnvironment()
    }
    
    private func setLogoForTitle() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
    }
    
    private func setKeyboardTapDismiss() {
        // make the keyboard disappear when tapping background
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(SettingsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        view.resignFirstResponder()
    }
    
    // Segment control tap
    @IBAction func environmentSwitchValueChange(_ sender: UISegmentedControl) {
        Settings.sharedInstance.save()
        Settings.setEnvironment(sender.selectedSegmentIndex)
        Settings.sharedInstance.reload()
        updateAllSettings()
        setupStoresDropDown()
        self.maskSwitch.setOn(false, animated: true)
    }
    
    func getMaskedURL ( urlToMask:String ) -> String {
        if (urlToMask.isEmpty) {
            return ""
        }
        let url = URL(string : urlToMask)
        if (url?.query != nil) {
            let maskedURL = "https://" + "xxxxxxxxxxx" + (url?.path)! + "?" + (url?.query)!
            return maskedURL
        } else {
            let maskedURL = "https://" + "xxxxxxxxxxx" + (url?.path)!
            return maskedURL
        }
    }
    
    func isMaskedURL ( urlToCheck:String ) -> Bool {
        if ( urlToCheck.range(of: "https://xxx") != nil ) {
            return true;
        } else {
            return false;
        }
    }
    
    @IBAction func maskSwitchValueChange(_ sender: Any) {
        let sharedInstance = Settings.sharedInstance
        if Settings.getEnvironment() == 0 {
            // LIVE
            simpleOrderFieldValue = CYBSMposSettingsLiveSimpleOrderAPIURL
            transactionSearchFieldValue = CYBSMposSettingsLiveTransactionSearchAPIURL
            transactionDetailFieldValue = CYBSMposSettingsLiveTransactionDetailAPIURL
            receiptFieldValue = CYBSMposSettingsLiveReceiptAPIURL
            substituteReceiptFieldValue = CYBSMposSettingsLiveSubstituteReceiptAPIURL
            oAuthTokenFieldValue = "https://auth.ic3.com/apiauth/v1/oauth/token"
            deviceRegistrationFieldValue = CYBSMposSettingsLiveDeviceRegistrationAPIURL
            //trustServerCertSwitch.isEnabled = false
        }
        else if Settings.getEnvironment() == 1 {
            // TEST
            simpleOrderFieldValue = CYBSMposSettingsTestSimpleOrderAPIURL
            transactionSearchFieldValue = CYBSMposSettingsTestTransactionSearchAPIURL
            transactionDetailFieldValue = CYBSMposSettingsTestTransactionDetailAPIURL
            receiptFieldValue = CYBSMposSettingsTestReceiptAPIURL
            substituteReceiptFieldValue = CYBSMposSettingsTestSubstituteReceiptAPIURL
            oAuthTokenFieldValue = "https://authtest.ic3.com/apiauth/v1/oauth/token"
            deviceRegistrationFieldValue = CYBSMposSettingsTestDeviceRegistrationAPIURL
            //trustServerCertSwitch.isEnabled = false
        }
        simpleOrderVerFieldValue = sharedInstance.simpleOrderAPIVersion ?? DefaultSimpleOrderAPIVersion
        if (self.maskSwitch.isOn ) {
            simpleOrderFieldValue = simpleOrderField.text
            transactionSearchFieldValue = transactionSearchField.text
            transactionDetailFieldValue = transactionDetailField.text
            receiptFieldValue = receiptField.text
            substituteReceiptFieldValue = substituteReceiptField.text
            oAuthTokenFieldValue = oAuthTokenField.text
            deviceRegistrationFieldValue = deviceRegistrationField.text
            simpleOrderVerFieldValue = simpleOrderVerField.text
            if let simpleOrderValue =  simpleOrderFieldValue {
                simpleOrderField.text = getMaskedURL(urlToMask: simpleOrderValue)
            }
            if let transactionSearchValue =  transactionSearchFieldValue {
                transactionSearchField.text = getMaskedURL(urlToMask: transactionSearchValue)
            }
            if let transactionDetailValue =  transactionDetailFieldValue {
                transactionDetailField.text = getMaskedURL(urlToMask: transactionDetailValue)
            }
            if let receiptValue =  receiptFieldValue {
                receiptField.text = getMaskedURL(urlToMask: receiptValue)
            }
            if let substituteReceiptValue =  substituteReceiptFieldValue {
                substituteReceiptField.text = getMaskedURL(urlToMask: substituteReceiptValue)
            }
            if let oAuthTokenValue =  oAuthTokenFieldValue {
                oAuthTokenField.text = getMaskedURL(urlToMask: oAuthTokenValue)
            }
            if let deviceRegistrationValue =  deviceRegistrationFieldValue {
                deviceRegistrationField.text = getMaskedURL(urlToMask: deviceRegistrationValue)
            }
            simpleOrderVerField.text = "x.xx"
            
            if ( Settings.getEnvironment() == 2 ) {
                simpleOrderField.isEnabled = false
                transactionSearchField.isEnabled = false
                transactionDetailField.isEnabled = false
                receiptField.isEnabled = false
                substituteReceiptField.isEnabled = false
                oAuthTokenField.isEnabled = false
                deviceRegistrationField.isEnabled = false
                trustServerCertSwitch.isEnabled = false
                simpleOrderVerField.isEnabled = true
            }
            
        } else {
            if ( Settings.getEnvironment() == 2 ) {
                simpleOrderField.isEnabled = true
                transactionSearchField.isEnabled = true
                transactionDetailField.isEnabled = true
                receiptField.isEnabled = true
                substituteReceiptField.isEnabled = true
                oAuthTokenField.isEnabled = true
                deviceRegistrationField.isEnabled = true
                trustServerCertSwitch.isEnabled = true
                simpleOrderVerField.isEnabled = true
            }
            
            simpleOrderField.text = simpleOrderFieldValue
            transactionSearchField.text = transactionSearchFieldValue
            transactionDetailField.text = transactionDetailFieldValue
            receiptField.text = receiptFieldValue
            substituteReceiptField.text = substituteReceiptFieldValue
            oAuthTokenField.text = oAuthTokenFieldValue
            deviceRegistrationField.text = deviceRegistrationFieldValue
            simpleOrderVerField.text = simpleOrderVerFieldValue
        }
    }
    
    @IBAction func enableTokenizationSwitchValueChange(_ sender: UISwitch) {
        Settings.sharedInstance.enableTokenization = sender.isOn
    }
    
    @IBAction func showReceiptSwitchValueChange(_ sender: UISwitch) {
        Settings.sharedInstance.showReceipt = sender.isOn
    }
    
    @IBAction func partialAuthSwitchValueChange(_ sender: UISwitch) {
        Settings.sharedInstance.partialAuthIndicator = sender.isOn
    }
    
    @IBAction func tipSwitchValueChange(_ sender: UISwitch) {
        Settings.sharedInstance.tipEnabled = sender.isOn
    }
    
    @IBAction func signatureSwitchValueChange(_ sender: UISwitch) {
        Settings.sharedInstance.signatureEnabled = sender.isOn
        if Settings.sharedInstance.signatureEnabled == true {
            minAmountField.isEnabled = true
        }
        else {
            minAmountField.isEnabled = false
        }
    }
    
    @IBAction func taxSwitchValueChange(_ sender: UISwitch) {
        Settings.sharedInstance.taxEnabled = sender.isOn
        if Settings.sharedInstance.taxEnabled == true {
            taxField.isEnabled = true
        }
        else {
            taxField.isEnabled = false
        }
    }
    
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var buildVersionLabel: UILabel!
    
    private func setVersions() {
        appVersionLabel.text = getAppVersion()
        buildVersionLabel.text = getBuildVersion()
    }
    
    func getAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    func getBuildVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    @IBAction func resetAllSettings(_ sender: Any) {
        Utils.resetSettings()
        Settings.sharedInstance.reload()
        environmentSegment.selectedSegmentIndex = Settings.defaultEnvironment
        updateAllSettings()
    }
    
    func updateAllSettings() {
        updateAccountSection()
        updateDecryptionServices()
        updateEndpointsSection()
        updateGeneratingAccessTokenSection()
        updatePos()
        updateServiceType()
        updatePartialAuthIndicator()
        updateCommerceIndicator()
        updateSignature()
        updateTax()
        updateTips()
        updateMerchantDefinedData()
        updateUiSettings()
        updateCurrencyUISettings()
    }
    
    func updateAccountSection() {
        let sharedInstance = Settings.sharedInstance
        storeNameField.text = sharedInstance.storeName
        merchantIdField.text = sharedInstance.merchantID
        deviceIdField.text = sharedInstance.deviceID
        clientIdField.text = sharedInstance.clientID
        clientSecretField.text = sharedInstance.clientSecret
        usernameField.text = sharedInstance.username
        passwordField.text = sharedInstance.password
        accessTokenField.text = sharedInstance.accessToken
    }
    
    func updateEndpointsSection() {
        let sharedInstance = Settings.sharedInstance
        simpleOrderField.isEnabled = false
        transactionSearchField.isEnabled = false
        transactionDetailField.isEnabled = false
        receiptField.isEnabled = false
        substituteReceiptField.isEnabled = false
        oAuthTokenField.isEnabled = false
        deviceRegistrationField.isEnabled = false
        simpleOrderVerField.isEnabled = true
        if Settings.getEnvironment() == 0 {
            // LIVE
            simpleOrderField.text = CYBSMposSettingsLiveSimpleOrderAPIURL
            transactionSearchField.text = CYBSMposSettingsLiveTransactionSearchAPIURL
            transactionDetailField.text = CYBSMposSettingsLiveTransactionDetailAPIURL
            receiptField.text = CYBSMposSettingsLiveReceiptAPIURL
            substituteReceiptField.text = CYBSMposSettingsLiveSubstituteReceiptAPIURL
            oAuthTokenField.text = "https://auth.ic3.com/apiauth/v1/oauth/token"
            deviceRegistrationField.text = CYBSMposSettingsLiveDeviceRegistrationAPIURL
            trustServerCertSwitch.isEnabled = false
        }
        else if Settings.getEnvironment() == 1 {
            // TEST
            simpleOrderField.text = CYBSMposSettingsTestSimpleOrderAPIURL
            transactionSearchField.text = CYBSMposSettingsTestTransactionSearchAPIURL
            transactionDetailField.text = CYBSMposSettingsTestTransactionDetailAPIURL
            receiptField.text = CYBSMposSettingsTestReceiptAPIURL
            substituteReceiptField.text = CYBSMposSettingsTestSubstituteReceiptAPIURL
            oAuthTokenField.text = "https://authtest.ic3.com/apiauth/v1/oauth/token"
            deviceRegistrationField.text = CYBSMposSettingsTestDeviceRegistrationAPIURL
            trustServerCertSwitch.isEnabled = false
        }
        simpleOrderVerField.text = sharedInstance.simpleOrderAPIVersion
    }
    
    func updateGeneratingAccessTokenSection() {
        // Settings.sharedInstance.generatingAccessTokenMethod
        tableView.reloadSections([Section.GeneratingAccessToken.rawValue], with: UITableView.RowAnimation.none)
    }
    
    func updatePos() {
        terminalIdField.text = Settings.sharedInstance.terminalID
        alternateIdField.text = Settings.sharedInstance.terminalIDAlternate
        mIdField.text = Settings.sharedInstance.mid
    }

    func updateDecryptionServices() {
        tableView.reloadSections([Section.DecryptionServices.rawValue], with: UITableView.RowAnimation.none)
    }
    
    func updateServiceType() {
        tableView.reloadSections([Section.SupportedServices.rawValue], with: UITableView.RowAnimation.none)
    }
    
    func updatePartialAuthIndicator() {
        partialAuthSwitch.isOn = Settings.sharedInstance.partialAuthIndicator
    }
    
    func updateCommerceIndicator() {
        tableView.reloadSections([Section.commerceIndicator.rawValue], with: UITableView.RowAnimation.none)
    }
    
    func updateSignature() {
        minAmountField.text = String(Settings.sharedInstance.signatureMinAmount)
        if Settings.sharedInstance.signatureEnabled == true {
            minAmountField.isEnabled = true
            signatureSwitch.isOn = true
        }
        else {
            minAmountField.isEnabled = false
            signatureSwitch.isOn = false
        }
    }
    
    func updateTax() {
        taxField.text = Settings.sharedInstance.taxRate ?? "8.25"
        if Settings.sharedInstance.taxEnabled == true {
            taxField.isEnabled = true
        }
        else {
            taxField.isEnabled = false
        }
        taxSwitch.isOn = Settings.sharedInstance.taxEnabled

    }
    
    func updateTips() {
        tipsSwitch.isOn = Settings.sharedInstance.tipEnabled
    }
    
    func updateMerchantDefinedData() {
        mDdField1.text = Settings.sharedInstance.mddField1
        mDdField2.text = Settings.sharedInstance.mddField2
        mDdField3.text = Settings.sharedInstance.mddField3
        mDdField4.text = Settings.sharedInstance.mddField4
        mDdField5.text = Settings.sharedInstance.mddField5
        merchantTransactionIdentifier.text = Settings.sharedInstance.merchantTransactionIdentifier
    }
    
    func updateUiSettings() {
        topImageUrlField.text = Settings.sharedInstance.topImageURL
        backgroundColorField.text = Settings.sharedInstance.backgroundColor
        spinnerColorField.text = Settings.sharedInstance.spinnerColor
        TextLabelColorField.text = Settings.sharedInstance.textLabelColor
        detailLabelColorField.text = Settings.sharedInstance.detailLabelColor
        textFieldColorField.text = Settings.sharedInstance.textFieldColor
        placeholderColorField.text = Settings.sharedInstance.placeholderColor
        signatureColorField.text = Settings.sharedInstance.signatureColor
        signatureBgColorField.text = Settings.sharedInstance.signatureBackgroundColor
        tintColorField.text = Settings.sharedInstance.tintColor
        ultraLightFontField.text = Settings.sharedInstance.ultraLightFont
        thinFontField.text = Settings.sharedInstance.thinFont
        lightFontField.text = Settings.sharedInstance.lightFont
        regularFontField.text = Settings.sharedInstance.regularFont
        mediumFontField.text = Settings.sharedInstance.mediumFont
        semiboldFontField.text = Settings.sharedInstance.semiboldFont
        boldFontField.text = Settings.sharedInstance.boldFont
        heavyFontField.text = Settings.sharedInstance.heavyFont
        blackFontField.text = Settings.sharedInstance.blackFont
        showReceiptSwitch.isOn = Settings.sharedInstance.showReceipt
    }
    
    func updateCurrencyUISettings() {
        currencyField.text = Settings.sharedInstance.currency
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.GeneratingAccessToken.rawValue {
            Settings.sharedInstance.generatingAccessTokenMethod = indexPath.row
        }
        else if indexPath.section == Section.DecryptionServices.rawValue {
            Settings.sharedInstance.decryptionServiceType = indexPath.row
        }
        else if indexPath.section == Section.SupportedServices.rawValue {
            Settings.sharedInstance.serviceType = indexPath.row
        }
        else if indexPath.section == Section.commerceIndicator.rawValue {
            Settings.sharedInstance.commereceIndicator = indexPath.row
        }
        else if (indexPath.section == Section.about.rawValue) {
            switch indexPath.row {
            case 2:
                performSegue(withIdentifier: "aboutVC", sender: 1)
                break
            case 3:
                performSegue(withIdentifier: "aboutVC", sender: 2)
                break
            default: break
            }
        }
        tableView.reloadSections([indexPath.section], with: .none)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .none
        cell.selectionStyle = .none
        if indexPath.section == Section.GeneratingAccessToken.rawValue {
            cell.selectionStyle = .default
            if indexPath.row == Settings.sharedInstance.generatingAccessTokenMethod {
                cell.accessoryType = .checkmark
            }
        }
        else if indexPath.section == Section.DecryptionServices.rawValue {
            cell.selectionStyle = .default
            if indexPath.row == Settings.sharedInstance.decryptionServiceType {
                cell.accessoryType = .checkmark
            }
        }
        else if indexPath.section == Section.SupportedServices.rawValue {
            cell.selectionStyle = .default
            if indexPath.row == Settings.sharedInstance.serviceType {
                cell.accessoryType = .checkmark
            }
        }
        else if indexPath.section == Section.commerceIndicator.rawValue {
            cell.selectionStyle = .default
            if indexPath.row == Settings.sharedInstance.commereceIndicator {
                cell.accessoryType = .checkmark
            }
        }
        else if indexPath.section == Section.resetAllSettings.rawValue {
            cell.selectionStyle = .default
        }
        
        if (indexPath.section == Section.OTA.rawValue || indexPath.section == Section.Address.rawValue) {
            cell.accessoryType = .disclosureIndicator
        }
        if (indexPath.section == Section.about.rawValue) {
            switch indexPath.row {
            case 2,3:
                cell.accessoryType = .disclosureIndicator
                break
            default:
                cell.accessoryType = .none
            }
        }
        return cell
    }

}

extension SettingsViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        // Account
        case merchantIdField:
            Settings.sharedInstance.merchantID = textField.text; break
        case deviceIdField:
            Settings.sharedInstance.deviceID = textField.text; break
        case clientIdField:
            Settings.sharedInstance.clientID = textField.text; break
        case clientSecretField:
            Settings.sharedInstance.clientSecret = textField.text; break
        case usernameField:
            Settings.sharedInstance.username = textField.text; break
        case passwordField:
            Settings.sharedInstance.password = textField.text; break
        case accessTokenField:
            Settings.sharedInstance.accessToken = textField.text; break
        // POS
        case terminalIdField:
            Settings.sharedInstance.terminalID = textField.text; break
        case alternateIdField:
            Settings.sharedInstance.terminalIDAlternate = textField.text; break
        case mIdField:
            Settings.sharedInstance.mid = textField.text; break
        // Signature
        case minAmountField:
            if let amount = Float(textField.text!) {
                Settings.sharedInstance.signatureMinAmount = amount
            }
            else {
                textField.text = String(1)
            }
            break
        // Merchant Defined Data
        case mDdField1:
            Settings.sharedInstance.mddField1 = textField.text; break
        case mDdField2:
            Settings.sharedInstance.mddField2 = textField.text; break
        case mDdField3:
            Settings.sharedInstance.mddField3 = textField.text; break
        case mDdField4:
            Settings.sharedInstance.mddField4 = textField.text; break
        case mDdField5:
            Settings.sharedInstance.mddField5 = textField.text; break
        case merchantTransactionIdentifier:
            Settings.sharedInstance.merchantTransactionIdentifier = textField.text; break
        // UI Settings
        case topImageUrlField:
            Settings.sharedInstance.topImageURL = textField.text; break
        case backgroundColorField:
            Settings.sharedInstance.backgroundColor = textField.text; break
        case spinnerColorField:
            Settings.sharedInstance.spinnerColor = textField.text; break
        case TextLabelColorField:
            Settings.sharedInstance.textLabelColor = textField.text; break
        case detailLabelColorField:
            Settings.sharedInstance.detailLabelColor = textField.text; break
        case textFieldColorField:
            Settings.sharedInstance.textFieldColor = textField.text; break
        case placeholderColorField:
            Settings.sharedInstance.placeholderColor = textField.text; break
        case signatureColorField:
            Settings.sharedInstance.signatureColor = textField.text; break
        case signatureBgColorField:
            Settings.sharedInstance.signatureBackgroundColor = textField.text; break
        case tintColorField:
            Settings.sharedInstance.tintColor = textField.text; break
        case ultraLightFontField:
            Settings.sharedInstance.ultraLightFont = textField.text; break
        case thinFontField:
            Settings.sharedInstance.thinFont = textField.text; break
        case lightFontField:
            Settings.sharedInstance.lightFont = textField.text; break
        case regularFontField:
            Settings.sharedInstance.regularFont = textField.text; break
        case mediumFontField:
            Settings.sharedInstance.mediumFont = textField.text; break
        case semiboldFontField:
            Settings.sharedInstance.semiboldFont = textField.text; break
        case boldFontField:
            Settings.sharedInstance.boldFont = textField.text; break
        case heavyFontField:
            Settings.sharedInstance.heavyFont = textField.text; break
        case blackFontField:
            Settings.sharedInstance.blackFont = textField.text; break
        case currencyField:
            Settings.sharedInstance.currency = textField.text?.uppercased(); break
        case taxField:
                Settings.sharedInstance.taxRate = textField.text; break
        default:
            break
        }
    }
    
    func readStoreInfo() {
        self.copyConfigurationFileIfNeeded()
        
        if let path = getDocuemntsFileURL()?.path {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if  let storeDict = jsonResult as? [String : Any],
                    let casData = storeDict["LIVE"] as? [[String : Any]] {
                    self.storesDataLIVE = self.readJsonData(inData: casData)
                }
                
                if  let storeDict = jsonResult as? [String : Any],
                    let casData = storeDict["CAS"] as? [[String : Any]] {
                    self.storesDataCAS = self.readJsonData(inData: casData)
                }
                
                if  let storeDict = jsonResult as? [String : Any],
                    let casData = storeDict["CUSTOM"] as? [[String : Any]] {
                    self.storesDataCUSTOM = self.readJsonData(inData: casData)
                }
            } catch {
                // handle error
            }
        }
    }

    func readJsonData(inData: [[String : Any]]) -> Array<StoreAttribute> {
        var resultArray = Array<StoreAttribute> ()
        
        for store in inData {
            let storename = store["Store_Name"] as! String
            let merchantid = store["CyberSource_MID"] as! String
            let deviceid = store["Device_ID"] as! String
            let clientid = store["Client_ID"] as! String
            let terminalid = store["Terminal_ID"] as! String
            
            let data = StoreAttribute(storeName: storename, merchantId: merchantid, deviceId: deviceid, clientId: clientid, terminalId: terminalid)
            resultArray.append(data)
        }
        return resultArray
    }
    
    func getDocuemntsFileURL() -> URL? {
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return nil// Could not find documents URL
        }
        
        let finalConfigFileURL = documentsUrl.first!.appendingPathComponent("StoresConfiguration.json")

        return finalConfigFileURL
    }
    
    func copyConfigurationFileIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalConfigFileURL = documentsUrl.first!.appendingPathComponent("StoresConfiguration.json")
        
        if !( (try? finalConfigFileURL.checkResourceIsReachable()) ?? false) {
            print("Stores configuration file does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("StoresConfiguration.json")
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalConfigFileURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Stores configuration file found at path: \(finalConfigFileURL.path)")
        }
    }
    
        @IBAction func chooseStore(_ sender: AnyObject) {
        chooseStoreDropDown.show()
    }
    
    func setupStoresDropDown() {
        self.chooseStoreDropDown.anchorView = self.storeNameField
        
        // Will set a custom with instead of anchor view width
        //        dropDown.width = 100
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        chooseStoreDropDown.bottomOffset = CGPoint(x: 0, y: storeNameField.bounds.height)
        
        var storeNamesList = Array<String> ()
        // You can also use localizationKeysDataSource instead. Check the docs.
        if Settings.getEnvironment() == 0 {
            //LIVE
            for store in self.storesDataLIVE {
                storeNamesList.append(store.storeName)
            }
        } else if Settings.getEnvironment() == 1 {
            //TEST
            for store in self.storesDataCAS {
                storeNamesList.append(store.storeName)
            }
        } else {
            //CUSTOM
            for store in self.storesDataCUSTOM {
                storeNamesList.append(store.storeName)
            }
        }
        chooseStoreDropDown.dataSource = storeNamesList
        
        // Action triggered on selection
        chooseStoreDropDown.selectionAction = { [weak self] (index, item) in
            Utils.clearAccessToken()
            let selectedStoreData = self?.retrieveStoreData(environmnt: Settings.getEnvironment(), selectedStoreName: item)
            self?.updateStoreData(selectedStoreData: selectedStoreData!)
        }
    }
    
    func retrieveStoreData(environmnt: Int, selectedStoreName: String) -> StoreAttribute? {
        var result = StoreAttribute(storeName: "NA", merchantId: "", deviceId: "", clientId: "", terminalId: "")
        if environmnt == 0 {
            //LIVE
            for store in self.storesDataLIVE {
                if selectedStoreName == store.storeName {
                    result = store
                    break
                }
            }
        } else if environmnt == 1 {
            //TEST
            for store in self.storesDataCAS {
                if selectedStoreName == store.storeName {
                    result = store
                    break
                }
            }
        } else {
            //CUSTOM
            //need different account settings for CUSTOM?
            for store in self.storesDataCUSTOM {
                if selectedStoreName == store.storeName {
                    result = store
                    break
                }
            }
        }
        
        return result
    }
    
    func updateStoreData(selectedStoreData: StoreAttribute) {
        Settings.sharedInstance.storeName = selectedStoreData.storeName
        Settings.sharedInstance.merchantID = selectedStoreData.merchantId
        Settings.sharedInstance.deviceID = selectedStoreData.deviceId
        Settings.sharedInstance.clientID = selectedStoreData.clientId
        Settings.sharedInstance.terminalID = selectedStoreData.terminalId
        
        self.storeNameField.text = selectedStoreData.storeName
        self.merchantIdField.text = selectedStoreData.merchantId
        self.deviceIdField.text = selectedStoreData.deviceId
        self.clientIdField.text = selectedStoreData.clientId
        self.terminalIdField.text = selectedStoreData.terminalId
        
        Settings.sharedInstance.save()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "aboutVC" {
            let vc = segue.destination as! AboutWebViewController
            if let about = sender as? Int {
                switch about {
                case 1:
                    vc.aboutSection = .PrivacyPolicy
                    break
                case 2:
                    vc.aboutSection = .HelpFeedback
                    break
                
                default:
                    vc.aboutSection = .PrivacyPolicy
                }
                
                //vc.aboutSection = about
            }
        }
    }
}






