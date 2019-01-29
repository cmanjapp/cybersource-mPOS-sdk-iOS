//
//  Created by CyberSource on 1/28/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit
import CoreBluetooth
import ExternalAccessory

class ItemDetails: NSObject {
    var itemName:String?
    var itemQuantity:NSInteger?
    var itemizedAmount:NSDecimalNumber

    override init() {
        itemName = nil
        itemQuantity = 0
        itemizedAmount = 0.0
    }
}

class PlaceOrderViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ItemCellProtocol,AddItemsViewControllerDelegate,MonthYearPickerViewProtocol {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var deviceInfoLabel: UILabel!
    @IBOutlet weak var bluetoothBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var subTotalLabel: UITextField!
    @IBOutlet weak var merchantRefCodeTextField: UITextField!
    

    var transactionRequest:CYBSMposPaymentRequest?
    var transactionResponse:CYBSMposPaymentResponse?
    
    var isAudioDeviceConnected:Bool?
    var accessToken: String?
    var deviceList = [CYBSMposBluetoothDevice]()
    var manager: CYBSMposManager {
        get {
            return Utils.getManager()
        }
    }
    var items = Array<ItemDetails>()

    // MARK: - UIViewController
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        Settings.sharedInstance.reload()
        
        let view = self.view as! PlaceOrderView
        
        view.resultTableView.delegate = self
        view.resultTableView.dataSource = self
        
        view.payByCardReaderButton.isEnabled = false
        view.payBySwipeButton.isEnabled = false
        view.payByManualButton.isEnabled = false
        
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.hidesWhenStopped = true
        //self.manager = self.getManager()
        self.manager.delegate = self
        //self.itemsTableView.setEditing(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.calculateSubtotalAndItemCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.subTotalLabel.delegate = self
        self.subTotalLabel.keyboardType = UIKeyboardType.decimalPad
        self.merchantRefCodeTextField.autocorrectionType = UITextAutocorrectionType.no
    }
    
    func addItemsDidFinish(addItemsViewController: AddItemsViewController) {
        self.calculateSubtotalAndItemCount()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCartSegue" {
            let addItemViewController = segue.destination as! AddItemsViewController
            addItemViewController.delegate = self
        }
        if segue.identifier == "keyedInSegue" {
            if let destinationVC = segue.destination as? EnterKeyedInDetailsViewController {
                destinationVC.amount = self.subTotalLabel.text
                destinationVC.myDelegate = self
                if self.subTotalLabel.text?.count == 0 {
                    destinationVC.amount = "0.00"
                }
                destinationVC.merchantRefCode = self.merchantRefCodeTextField.text
            }
        }
    }
    
    func getServiceTypeRow(row: Int) -> CYBSMposPaymentRequestSupportedServices {
        switch row {
        case 0:
            return CYBSMposPaymentRequestSupportedServices.retail
        case 1:
            return CYBSMposPaymentRequestSupportedServices.tokenizedRetail
        case 2:
            return CYBSMposPaymentRequestSupportedServices.endlessAisle
        case 3:
            return CYBSMposPaymentRequestSupportedServices.tokenizedEndlessAisle
        case 4:
            return CYBSMposPaymentRequestSupportedServices.tokenized
        default:
            return CYBSMposPaymentRequestSupportedServices.retail
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func pay(_ sender: AnyObject) {
        Utils.createAccessToken { (accessToken, error) in
            if let accessToken = accessToken {
                self.accessToken = accessToken
                let merchantID = Settings.sharedInstance.merchantID ?? ""
                var merchantRefCode = "CybsmPOSiOS"
                if (self.merchantRefCodeTextField.text?.count != 0) {
                    merchantRefCode = self.merchantRefCodeTextField.text!
                }
                var currency = Settings.sharedInstance.currency?.uppercased()
                if (currency ?? "").isEmpty {
                    currency = "USD"
                }
                var amount:NSDecimalNumber = 0.0
                if self.subTotalLabel.text != "" {
                    amount = NSDecimalNumber(string: self.subTotalLabel.text!)
                }
                let minAmountForSignature = Settings.sharedInstance.signatureMinAmount
                var skipSignatureView = false
                if(amount.compare(NSDecimalNumber(value: minAmountForSignature)) == .orderedAscending){
                    skipSignatureView = true
                }
                let commInd = CYBSMposPaymentRequestCommerceIndicator(rawValue: UInt(Settings.sharedInstance.commereceIndicator))
                let paymentRequest = CYBSMposPaymentRequest(merchantID: merchantID, accessToken: accessToken, amount: amount, entryMode: .swipeOrInsertOrTap)
                if (Settings.sharedInstance.merchantTransactionIdentifier?.count != 0) {
                    paymentRequest.merchantTransactionIdentifier = Settings.sharedInstance.merchantTransactionIdentifier
                }
                paymentRequest.showReceiptView = Settings.sharedInstance.showReceipt
                paymentRequest.paymentService = self.getServiceTypeRow(row: Settings.sharedInstance.serviceType)
                paymentRequest.decryptionService = CYBSMposPaymentRequestDecryptionServices(rawValue: UInt(Settings.sharedInstance.decryptionServiceType))!
                paymentRequest.skipSignature = skipSignatureView
                paymentRequest.merchantDefinedDataArray = self.getMDDFields()
                paymentRequest.merchantReferenceCode = merchantRefCode
                paymentRequest.purchaseTotal.currency = currency!
                paymentRequest.commerceIndicator = commInd!
                paymentRequest.items = self.getItemsList()
                paymentRequest.shippingAddress = AddressData.sharedInstance.getShippingAddress()
                paymentRequest.billingAddress = AddressData.sharedInstance.getBillingAddress()
                paymentRequest.partialIndicator = Settings.sharedInstance.partialAuthIndicator
                self.transactionRequest = paymentRequest

                self.manager.performPayment(paymentRequest, parentViewController: self, delegate: self)
            } else {
                self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
            }
        }
    }
    
    @IBAction func goToCartClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCartSegue", sender:self)
    }
    
    @IBAction func swipeCard(_ sender: UIButton) {
        Utils.createAccessToken { (accessToken, error) in
            if let accessToken = accessToken {
                self.accessToken = accessToken
                let merchantID = Settings.sharedInstance.merchantID ?? ""
                var merchantRefCode = "CybsmPOSiOS"
                if (self.merchantRefCodeTextField.text?.count != 0) {
                    merchantRefCode = self.merchantRefCodeTextField.text!
                }
                var currency = Settings.sharedInstance.currency?.uppercased()
                if (currency ?? "").isEmpty {
                    currency = "USD"
                }
                var amount:NSDecimalNumber = 0.0
                if self.subTotalLabel.text != "" {
                    amount = NSDecimalNumber(string: self.subTotalLabel.text!)
                }
                let minAmountForSignature = Settings.sharedInstance.signatureMinAmount
                var skipSignatureView = false
                if(amount.compare(NSDecimalNumber(value: minAmountForSignature)) == .orderedAscending){
                    skipSignatureView = true
                }
                let commInd = CYBSMposPaymentRequestCommerceIndicator(rawValue: UInt(Settings.sharedInstance.commereceIndicator))
                let paymentRequest = CYBSMposPaymentRequest(merchantID: merchantID, accessToken: accessToken, amount: amount, entryMode: .swipe)
                if (Settings.sharedInstance.merchantTransactionIdentifier?.count != 0) {
                    paymentRequest.merchantTransactionIdentifier = Settings.sharedInstance.merchantTransactionIdentifier
                }
                paymentRequest.showReceiptView = Settings.sharedInstance.showReceipt
                paymentRequest.paymentService = self.getServiceTypeRow(row: Settings.sharedInstance.serviceType)
                paymentRequest.decryptionService = CYBSMposPaymentRequestDecryptionServices(rawValue: UInt(Settings.sharedInstance.decryptionServiceType))!
                paymentRequest.skipSignature = skipSignatureView
                paymentRequest.merchantDefinedDataArray = self.getMDDFields()
                paymentRequest.merchantReferenceCode = merchantRefCode
                paymentRequest.purchaseTotal.currency = currency!
                paymentRequest.commerceIndicator = commInd!
                paymentRequest.items = self.getItemsList()
                paymentRequest.shippingAddress = AddressData.sharedInstance.getShippingAddress()
                paymentRequest.billingAddress = AddressData.sharedInstance.getBillingAddress()
                paymentRequest.partialIndicator = Settings.sharedInstance.partialAuthIndicator

                self.transactionRequest = paymentRequest

                self.manager.performPayment(paymentRequest, parentViewController: self, delegate: self)
            } else {
                self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
            }
        }
    }
    
    
    @IBAction func appKeyEntry(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "keyedInSegue", sender: self)
        return
    }
    
    @IBAction func readerKeyEntry(_ sender: UIButton) {
        Utils.createAccessToken { (accessToken, error) in
            if let accessToken = accessToken {
                self.accessToken = accessToken
                let merchantID = Settings.sharedInstance.merchantID ?? ""
                var merchantRefCode = "CybsmPOSiOS"
                if (self.merchantRefCodeTextField.text?.count != 0) {
                    merchantRefCode = self.merchantRefCodeTextField.text!
                }
                var currency = Settings.sharedInstance.currency?.uppercased()
                if (currency ?? "").isEmpty {
                    currency = "USD"
                }
                var amount:NSDecimalNumber = 0.0
                if self.subTotalLabel.text != "" {
                    amount = NSDecimalNumber(string: self.subTotalLabel.text!)
                }
                let minAmountForSignature = Settings.sharedInstance.signatureMinAmount
                var skipSignatureView = false
                if(amount.compare(NSDecimalNumber(value: minAmountForSignature)) == .orderedAscending){
                    skipSignatureView = true
                }
                let commInd = CYBSMposPaymentRequestCommerceIndicator(rawValue: UInt(Settings.sharedInstance.commereceIndicator))
                let paymentRequest = CYBSMposPaymentRequest(merchantID: merchantID, accessToken: accessToken, amount: amount, entryMode: .readerKeyEntry)
                if (Settings.sharedInstance.merchantTransactionIdentifier?.count != 0) {
                    paymentRequest.merchantTransactionIdentifier = Settings.sharedInstance.merchantTransactionIdentifier
                }
                paymentRequest.showReceiptView = Settings.sharedInstance.showReceipt
                paymentRequest.paymentService = self.getServiceTypeRow(row: Settings.sharedInstance.serviceType)
                paymentRequest.decryptionService = CYBSMposPaymentRequestDecryptionServices(rawValue: UInt(Settings.sharedInstance.decryptionServiceType))!
                paymentRequest.skipSignature = skipSignatureView
                paymentRequest.merchantDefinedDataArray = self.getMDDFields()
                paymentRequest.merchantReferenceCode = merchantRefCode
                paymentRequest.purchaseTotal.currency = currency!
                paymentRequest.commerceIndicator = commInd!
                paymentRequest.items = self.getItemsList()
                paymentRequest.shippingAddress = AddressData.sharedInstance.getShippingAddress()
                paymentRequest.billingAddress = AddressData.sharedInstance.getBillingAddress()
                paymentRequest.partialIndicator = Settings.sharedInstance.partialAuthIndicator

                self.transactionRequest = paymentRequest

                self.manager.performPayment(paymentRequest, parentViewController: self, delegate: self)
            } else {
                self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
            }
        }
    }
    
    func onNoAudioDeviceDetected() {
        self.isAudioDeviceConnected = false
        NSLog("No Audio Device Detected by the App")
        self.showAlert("Error",message: "No Audio Device Detected")
        self.audioBtn.setTitle("Start Audio", for: .normal)
        self.bluetoothBtn.isEnabled = true
        self.bluetoothBtn.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        let view = self.view as! PlaceOrderView
        view.payByCardReaderButton.isEnabled = false
        view.payBySwipeButton.isEnabled = false
        view.payByManualButton.isEnabled = false
        view.resultTableView.allowsSelection = true
    }
    
    @IBAction func audioButtonTapped(_ sender: UIButton) {
        self.spinner.stopAnimating()
        if sender.titleLabel?.text == "Start Audio" {
            isAudioDeviceConnected = true
            self.manager.startAudio(self)
            if (self.isAudioDeviceConnected == true){
                sender.setTitle("Stop Audio", for: .normal)
            }
            else {
                return;
            }
            let view = self.view as! PlaceOrderView
            self.bluetoothBtn.isEnabled = false
            self.bluetoothBtn.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 0.5)
            view.payByCardReaderButton.isEnabled = true
            view.payBySwipeButton.isEnabled = true
            view.payByManualButton.isEnabled = true
            view.resultTableView.allowsSelection = false
            self.manager.getDeviceInfo(self)
        }
        else {
            sender.setTitle("Start Audio", for: .normal)
            self.bluetoothBtn.isEnabled = true
            self.bluetoothBtn.backgroundColor = UIColor.blue
            self.manager.stopAudio(self)
            let view = self.view as! PlaceOrderView
            view.payByCardReaderButton.isEnabled = false
            view.payBySwipeButton.isEnabled = false
            view.payByManualButton.isEnabled = false
            view.resultTableView.allowsSelection = true
            deviceInfoLabel.text = ""
        }
    }
    
    
    func onBTScanTimeout() {
        NSLog("________ Bluetooth Scan Timeout_______")
        self.audioBtn.isEnabled = true
        self.audioBtn.backgroundColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1.0)
        self.spinner.stopAnimating()
    }
    
    func onRequestEnableBluetoothInSettings(){
        NSLog("BlueTooth is turned off.")
        self.audioBtn.isEnabled = true
        self.audioBtn.backgroundColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1.0)
        self.spinner.stopAnimating()
        self.showAlert("Error",message: "Please Turn On the BlueTooth")
    }
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        self.spinner.stopAnimating()
        self.manager.stopAudio(self)
        self.deviceInfoLabel.text = ""
        if(sender.titleLabel?.text?.elementsEqual("Disconnect BT"))!{
            sender.setTitle("Scan BT devices", for: .normal)
            self.manager.disconenctBTDevice(self)
            let view = self.view as! PlaceOrderView
            view.bluetoothBtn.setTitle("Scan BT Devices", for: .normal)
            deviceList = [CYBSMposBluetoothDevice]()
            view.resultTableView.reloadData()
            view.payByCardReaderButton.isEnabled = false
            view.payBySwipeButton.isEnabled = false
            view.payByManualButton.isEnabled = false
            view.resultTableView.allowsSelection = true
            deviceInfoLabel.text = ""
        }else{
            self.audioBtn.isEnabled = false
            self.audioBtn.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 0.5)
            self.manager.scanBTDevices(self)
            self.spinner.startAnimating()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let view = self.view as! PlaceOrderView
        if (tableView == view.resultTableView) {
            return 75
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let view = self.view as! PlaceOrderView
        if (tableView == view.resultTableView) {
            return (deviceList.count)
        } else {
            return (self.items.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curDevice = deviceList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothDeviceCell", for: indexPath)
        cell.textLabel?.text = "Name"
        cell.detailTextLabel?.text = curDevice.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.view as! PlaceOrderView
        if (tableView == view.resultTableView) {
            let selecteDevice = deviceList[indexPath.row]
            manager.connectBTDevice(selecteDevice)
            self.spinner.startAnimating()
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
        
    // MARK: -
    
    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {
        }
    }
    
    func dismissKeyboard() {
        let view = self.view as! PlaceOrderView
        if view.isKeyboardShown {
            view.endEditing(true)
            view.isKeyboardShown = false
        } else {
            view.becomeFirstResponder()
            view.isKeyboardShown = true
        }
    }
    
    func getMDDFields() -> [String]{
        var mddFieldsArray:[String] = []
        if let field1 = Settings.sharedInstance.mddField1{
            mddFieldsArray.append(field1)
        }
        if let field2 = Settings.sharedInstance.mddField2{
            mddFieldsArray.append(field2)
        }
        if let field3 = Settings.sharedInstance.mddField3{
            mddFieldsArray.append(field3)
        }
        if let field4 = Settings.sharedInstance.mddField4{
            mddFieldsArray.append(field4)
        }
        if let field5 = Settings.sharedInstance.mddField5{
            mddFieldsArray.append(field5)
        }
        return mddFieldsArray
    }
    
    func getItemsList() -> Array<CYBSMposItem> {
        var itemsList = Array<CYBSMposItem>()
        
        for item in CartData.sharedInstance.items {
            let lineItem = CYBSMposItem()
            lineItem.name = item.itemName
            lineItem.quantity = item.itemQuantity!
            lineItem.price = item.itemizedAmount
            
            itemsList.append(lineItem)
        }
        
        return itemsList
    }
    
    func calculateSubtotalAndItemCount() {
        let cart = CartData.sharedInstance
        var finalTotal:Float = 0.0
        for item in cart.items {
            var subTotal:Float = 0.0
            subTotal = subTotal.adding(Float(item.itemizedAmount))
            subTotal = subTotal.multiplied(by: Float(item.itemQuantity!))
            
            finalTotal = finalTotal + subTotal
        }
        self.subTotalLabel.text = String(format: "%.2f", finalTotal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.tag == 11) {
            let dotString = "."
            
            if let text = textField.text {
                let isDeleteKey = string.isEmpty
                
                if !isDeleteKey {
                    if text.contains(dotString) {
                        if text.components(separatedBy: dotString)[1].count == 2 {
                            return false
                        }
                        if (string == ".") {
                            return false
                        }
                    }
                    let num = Int(string)
                    if ((num == nil) && (string != ".")) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if (textField.tag == 20) {
            if (textField.text?.count == 31 && !(string == "")) {
                return false
            }  else {
                return true
            }
        } else if (textField.tag == 31) {
            let count:Int = (textField.text?.count)!
            if ((count >= 2) && string.count != 0) {
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == 11) {
            if (textField.text?.count == 0) {
                textField.text = "0.00"
            }
        }
    }
    
    func continueTransaction(cardData: CYBSMposCardDataManual?) {
        if let cardEntryData = cardData {
            self.spinner.startAnimating()
            self.spinner.bringSubview(toFront: self.view)
            Utils.createAccessToken { (accessToken, error) in
                if let accessToken = accessToken {
                    self.accessToken = accessToken
                    let merchantID = Settings.sharedInstance.merchantID ?? ""
                    var merchantRefCode = "CybsmPOSiOS"
                    if (self.merchantRefCodeTextField.text?.count != 0) {
                        merchantRefCode = self.merchantRefCodeTextField.text!
                    }
                    let currency = Settings.sharedInstance.currency ?? "USD"
                    var amount:NSDecimalNumber = 0.0
                    if self.subTotalLabel.text != "" {
                        amount = NSDecimalNumber(string: self.subTotalLabel.text!)
                    }
                    let minAmountForSignature = Settings.sharedInstance.signatureMinAmount
                    var skipSignatureView = false
                    if(amount.compare(NSDecimalNumber(value: minAmountForSignature)) == .orderedAscending || amount.compare(NSDecimalNumber(value: minAmountForSignature)) == .orderedSame){
                        skipSignatureView = true
                    }

                    let commInd = CYBSMposPaymentRequestCommerceIndicator(rawValue: UInt(Settings.sharedInstance.commereceIndicator))
                    let paymentRequest = CYBSMposPaymentRequest(merchantID: merchantID, accessToken: accessToken, amount: amount, entryMode: .appKeyEntry)
                    if (Settings.sharedInstance.merchantTransactionIdentifier?.count != 0) {
                        paymentRequest.merchantTransactionIdentifier = Settings.sharedInstance.merchantTransactionIdentifier
                    }
                    paymentRequest.showReceiptView = Settings.sharedInstance.showReceipt
                    paymentRequest.paymentService = self.getServiceTypeRow(row: Settings.sharedInstance.serviceType)
                    paymentRequest.decryptionService = CYBSMposPaymentRequestDecryptionServices(rawValue: UInt(Settings.sharedInstance.decryptionServiceType))!
                    paymentRequest.skipSignature = skipSignatureView
                    paymentRequest.merchantDefinedDataArray = self.getMDDFields()
                    paymentRequest.merchantReferenceCode = merchantRefCode
                    paymentRequest.purchaseTotal.currency = currency
                    paymentRequest.commerceIndicator = commInd!
                    paymentRequest.items = self.getItemsList()
                    paymentRequest.shippingAddress = AddressData.sharedInstance.getShippingAddress()
                    paymentRequest.billingAddress = AddressData.sharedInstance.getBillingAddress()
                    paymentRequest.partialIndicator = Settings.sharedInstance.partialAuthIndicator

                    self.transactionRequest = paymentRequest
                    paymentRequest.manualEntryCardData = cardEntryData
                    self.manager.performPayment(paymentRequest, parentViewController: self, delegate: self)
                } else {
                    self.spinner.stopAnimating()
                    self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
                }
            }
        }
    }
}


extension PlaceOrderViewController : CYBSMposManagerDelegate {
    // MARK: - CYBSMposManagerDelegate

    
    func onBTReturnScanResults(_ devices: [CYBSMposBluetoothDevice]?) {
        print("deviceList() Invoked. \(String(describing: devices))")
        self.spinner.stopAnimating()
        if let devices = devices {
            self.deviceList = devices
            let view = self.view as! PlaceOrderView
            view.resultTableView.reloadData()
        }
        else{
            self.deviceInfoLabel.text = "No devices found."
            self.deviceInfoLabel.textColor = UIColor.red
        }
    }
    
    
    func onBTDisconnected() {
        let view = self.view as! PlaceOrderView
        view.bluetoothBtn.setTitle("Scan BT Devices", for:UIControlState.normal)
        deviceList = [CYBSMposBluetoothDevice]()
        view.resultTableView.reloadData()
        view.payByCardReaderButton.isEnabled = false
        view.payBySwipeButton.isEnabled = false
        view.payByManualButton.isEnabled = false
        self.audioBtn.isEnabled = true
        self.audioBtn.backgroundColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1.0)
        view.resultTableView.allowsSelection = true
        deviceInfoLabel.text = ""
    }

    
    // This is for both audio and bluetooth
    func onBTConnected() {
        self.spinner.stopAnimating()
        let view = self.view as! PlaceOrderView
        view.bluetoothBtn.setTitle("Disconnect BT", for:UIControlState.normal)
        self.audioBtn.isEnabled = false
        self.audioBtn.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 0.5)
        view.payByCardReaderButton.isEnabled = true
        view.payBySwipeButton.isEnabled = true
        view.payByManualButton.isEnabled = true
        view.resultTableView.allowsSelection = false
        
        self.manager.getDeviceInfo(self)
    }

    func onReturnDeviceInfo(_ deviceInfo: [AnyHashable : Any]?) {
        let serial = deviceInfo?["serialNumber"]
        let keyConfig = deviceInfo?["terminalSettingVersion"]
        let firmware = deviceInfo?["firmwareVersion"]
        if let serial = serial {
            deviceInfoLabel.text = "Connected: (Serial Number: \(String(describing: serial))) (Key Config: \(String(describing: keyConfig!))) (Firware Version: \(String(describing: firmware!)))"
        } else {
            deviceInfoLabel.text = "Connected: ((Key Config: \(String(describing: keyConfig!))) (Firware Version: \(String(describing: firmware!)))"
        }
        self.deviceInfoLabel.textColor = UIColor.blue
    }
    
    
    func performPaymentDidFinish(_ result: CYBSMposPaymentResponse?, error: Error?) {
        self.spinner.stopAnimating()
        if let error = error {
            print("Received payment error: \(error.localizedDescription)")
            if Settings.sharedInstance.showReceipt == false {
                self.showAlert("Transaction Failed", message: error.localizedDescription)
            }
        }
        if (result?.reasonCode == "100") {
            self.transactionResponse = result
            Settings.sharedInstance.merchantTransactionIdentifier = ""
            Settings.sharedInstance.save()
            self.emailReceiptWith(result, error: error)
        } else {
            if Settings.sharedInstance.showReceipt == false {
                self.showAlert("Transaction Failed", message: (result?.reasonCode)!)
            }
        }

        debugPrint(result?.subscriptionID ?? "")
    }
    
    @IBAction func printButtonTapped() {
//        let formatter = ReceiptFormatter()
//        let receiptImg = formatter.getReceiptImage(for: self.transactionRequest, response: self.transactionResponse)
//        if let data = UIImageJPEGRepresentation(receiptImg!, 1.0) {
//            let filename = getDocumentsDirectory().appendingPathComponent("ReceiptJPGImage.jpg")
//            try? data.write(to: filename)
//
//            self.manager.printReceiptImage(receiptImg!, delegate: self)
//        }
        
        if let request = self.transactionRequest, let response = self.transactionResponse {
            self.manager.printReceipt(request, response: response, delegate: self)
        } else {
            self.showAlert("Error", message: "Invalid request or response")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func emailReceiptWith(_ result: CYBSMposPaymentResponse?, error: Error?) {
        guard result != nil else {
            return
        }
        let result = result!
        print("Received payment response: \(result.description)")
        guard error == nil else {
            return
        }
        let emailAlertController = UIAlertController(
            title: "Receipt",
            message: "Transaction successfull. Please enter your email address to receive an electronic receipt.",
            preferredStyle: .alert
        )
        emailAlertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Customer E-mail Address"
        })
        let skipAction = UIAlertAction(title: "Skip", style: .cancel, handler: nil)
        emailAlertController.addAction(skipAction)
        let doneAction = UIAlertAction(title: "Done", style: .default) { [unowned self](action) in
            if let toEmailAddress = emailAlertController.textFields![0].text {
                let receiptRequest = CYBSMposReceiptRequest(
                    toEmail: toEmailAddress,
                    fromEmail: "no-reply@cybersource.com",
                    emailSubject: "Your Transaction Receipt",
                    merchantDescriptor: "CyberSource",
                    merchantDescriptorStreet: "P.O. Box 8999",
                    merchantDescriptorCity: "San Francisco",
                    merchantDescriptorState: "CA",
                    merchantDescriptorPostalCode: "94128-8999",
                    merchantDescriptorCountry: "USA",
                    merchantReferenceCode: result.merchantReferenceCode ?? "",
                    authCode: result.authorizationCode ?? "",
                    shippingAmount: "USD $0.00",
                    taxAmount: "USD $0.00",
                    totalPurchaseAmount: "\(self.subTotalLabel.text!)",
                    subscriptionID: result.subscriptionID ?? "",
                    accessToken: self.accessToken ?? ""
                )
                
                receiptRequest.items = self.getItemsList()
                receiptRequest.emvTags = self.transactionResponse?.emvReply?.emvTags as? [Any]
                receiptRequest.suffix = self.transactionResponse?.card?.suffix
                receiptRequest.paymentMode = self.transactionResponse?.entryMode
                
                self.spinner.startAnimating()
                
                self.manager.sendReceipt(receiptRequest, delegate: self)
            }
        }
        emailAlertController.addAction(doneAction)
        self.present(emailAlertController, animated: true, completion: nil)
    }
    
    func sendReceiptDidFinish(_ result: [AnyHashable : Any]?, error: Error?) {
        self.spinner.stopAnimating()
        if let res = result, error == nil {
            if let message = res["message"] as? String {
                let alertController = UIAlertController(title: "Send Receipt",
                                                        message: message,
                                                        preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                }
                alertController.addAction(doneAction)
                self.present(alertController, animated: true) {
                }
            }
        }
    }
}
