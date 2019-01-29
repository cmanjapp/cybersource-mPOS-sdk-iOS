//
//  AddressViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 03/12/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import Foundation

class AddressData : NSObject {
    static let sharedInstance = AddressData()

    private var billTo = CYBSMposAddress()
    private var shipTo = CYBSMposAddress()
    
    func setBillingAddress(_ address: CYBSMposAddress) {
        billTo = address
    }
    
    func setShippingAddress(_ address: CYBSMposAddress) {
        shipTo = address
    }
    
    func getBillingAddress() -> CYBSMposAddress {
        return billTo
    }
    
    func getShippingAddress() -> CYBSMposAddress {
        return shipTo
    }
}

class AddressViewController : UITableViewController {
    @IBOutlet weak var billingFirstName: UITextField!
    @IBOutlet weak var billingLastName: UITextField!
    @IBOutlet weak var billingEmail: UITextField!
    @IBOutlet weak var billingPhone: UITextField!
    @IBOutlet weak var billingStreetAddr1: UITextField!
    @IBOutlet weak var billingStreetAddr2: UITextField!
    @IBOutlet weak var billingCity: UITextField!
    @IBOutlet weak var billingState: UITextField!
    @IBOutlet weak var billingZip: UITextField!
    @IBOutlet weak var billingCountry: UITextField!
    
    @IBOutlet weak var shippingFirstName: UITextField!
    @IBOutlet weak var shippingLastName: UITextField!
    @IBOutlet weak var shippingEmail: UITextField!
    @IBOutlet weak var shippingPhone: UITextField!
    @IBOutlet weak var shippingStreetAddr1: UITextField!
    @IBOutlet weak var shippingStreetAddr2: UITextField!
    @IBOutlet weak var shippingCity: UITextField!
    @IBOutlet weak var shippingState: UITextField!
    @IBOutlet weak var shippingZip: UITextField!
    @IBOutlet weak var shippingCountry: UITextField!

    var billTo = CYBSMposAddress()
    var shipTo = CYBSMposAddress()
    
    // MARK: - Settings view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.billTo = AddressData.sharedInstance.getBillingAddress()
        self.shipTo = AddressData.sharedInstance.getShippingAddress()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        
        self.tableView.addGestureRecognizer(tapGesture)
        
        self.initializeUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.saveAddress()
    }
    
    func initializeUI() {
        self.billingFirstName.text = self.billTo.firstName
        self.billingLastName.text = self.billTo.lastName
        self.billingStreetAddr1.text = self.billTo.street1
        self.billingStreetAddr2.text = self.billTo.street2
        self.billingCity.text = self.billTo.city
        self.billingState.text = self.billTo.state
        self.billingZip.text = self.billTo.postalCode
        self.billingCountry.text = self.billTo.country
        self.billingEmail.text = self.billTo.email
        self.billingPhone.text = self.billTo.phoneNumber
        
        self.shippingFirstName.text = self.shipTo.firstName
        self.shippingLastName.text = self.shipTo.lastName
        self.shippingStreetAddr1.text = self.shipTo.street1
        self.shippingStreetAddr2.text = self.shipTo.street2
        self.shippingCity.text = self.shipTo.city
        self.shippingState.text = self.shipTo.state
        self.shippingZip.text = self.shipTo.postalCode
        self.shippingCountry.text = self.shipTo.country
        self.shippingEmail.text = self.shipTo.email
        self.shippingPhone.text = self.shipTo.phoneNumber
    }
    
    @IBAction func uiSwitchChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            self.shippingFirstName.text = self.billingFirstName.text
            self.shipTo.firstName = self.billingFirstName.text
            self.shippingLastName.text = self.billingLastName.text
            self.shipTo.lastName = self.billingLastName.text
            self.shippingStreetAddr1.text = self.billingStreetAddr1.text
            self.shipTo.street1 = self.billingStreetAddr1.text
            self.shippingStreetAddr2.text = self.billingStreetAddr2.text
            self.shipTo.street2 = self.billingStreetAddr2.text
            self.shippingCity.text = self.billingCity.text
            self.shipTo.city = self.billingCity.text
            self.shippingState.text = self.billingState.text
            self.shipTo.state = self.billingState.text
            self.shippingZip.text = self.billingZip.text
            self.shipTo.postalCode = self.billingZip.text
            self.shippingCountry.text = self.billingCountry.text
            self.shipTo.country = self.billingCountry.text
            self.shippingEmail.text = self.billingEmail.text
            self.shipTo.email = self.billingEmail.text
            self.shippingPhone.text = self.billingPhone.text
            self.shipTo.phoneNumber = self.billingPhone.text
        } else {
            self.shippingFirstName.text = ""
            self.shipTo.firstName = ""
            self.shippingLastName.text = ""
            self.shipTo.lastName = ""
            self.shippingStreetAddr1.text = ""
            self.shipTo.street1 = ""
            self.shippingStreetAddr2.text = ""
            self.shipTo.street2 = ""
            self.shippingCity.text = ""
            self.shipTo.city = ""
            self.shippingState.text = ""
            self.shipTo.state = ""
            self.shippingZip.text = ""
            self.shipTo.postalCode = ""
            self.shippingCountry.text = ""
            self.shipTo.country = ""
            self.shippingEmail.text = ""
            self.shipTo.email = ""
            self.shippingPhone.text = ""
            self.shipTo.phoneNumber = ""
        }
        AddressData.sharedInstance.setShippingAddress(self.shipTo)
    }

    @IBAction func saveBtnTapped(_ sender: Any) {

        self.saveAddress()
        self.navigationController?.popViewController(animated: true)
    }

    func saveAddress() {
        self.billTo.firstName = self.billingFirstName.text
        self.billTo.lastName = self.billingLastName.text
        self.billTo.street1 = self.billingStreetAddr1.text
        self.billTo.street2 = self.billingStreetAddr2.text
        self.billTo.city = self.billingCity.text
        self.billTo.state = self.billingState.text
        self.billTo.postalCode = self.billingZip.text
        self.billTo.country = self.billingCountry.text
        self.billTo.email = self.billingEmail.text
        self.billTo.phoneNumber = self.billingPhone.text
        
        self.shipTo.firstName = self.shippingFirstName.text
        self.shipTo.lastName = self.shippingLastName.text
        self.shipTo.street1 = self.shippingStreetAddr1.text
        self.shipTo.street2 = self.shippingStreetAddr2.text
        self.shipTo.city = self.shippingCity.text
        self.shipTo.state = self.shippingState.text
        self.shipTo.postalCode = self.shippingZip.text
        self.shipTo.country = self.shippingCountry.text
        self.shipTo.email = self.shippingEmail.text
        self.shipTo.phoneNumber = self.shippingPhone.text
        
        AddressData.sharedInstance.setBillingAddress(self.billTo)
        AddressData.sharedInstance.setShippingAddress(self.shipTo)
    }
    
    @IBAction func clearBtnTapped(_ sender: Any) {
        self.billTo.firstName = ""
        self.billTo.lastName = ""
        self.billTo.street1 = ""
        self.billTo.street2 = ""
        self.billTo.city = ""
        self.billTo.state = ""
        self.billTo.postalCode = ""
        self.billTo.country = ""
        self.billTo.email = ""
        self.billTo.phoneNumber = ""

        self.shipTo.firstName = ""
        self.shipTo.lastName = ""
        self.shipTo.street1 = ""
        self.shipTo.street2 = ""
        self.shipTo.city = ""
        self.shipTo.state = ""
        self.shipTo.postalCode = ""
        self.shipTo.country = ""
        self.shipTo.email = ""
        self.shipTo.phoneNumber = ""

        self.billingFirstName.text = ""
        self.billingLastName.text = ""
        self.billingStreetAddr1.text = ""
        self.billingStreetAddr2.text = ""
        self.billingCity.text = ""
        self.billingState.text = ""
        self.billingZip.text = ""
        self.billingCountry.text = ""
        self.billingEmail.text = ""
        self.billingPhone.text = ""

        self.shippingFirstName.text = ""
        self.shippingLastName.text = ""
        self.shippingStreetAddr1.text = ""
        self.shippingStreetAddr2.text = ""
        self.shippingCity.text = ""
        self.shippingState.text = ""
        self.shippingZip.text = ""
        self.shippingCountry.text = ""
        self.shippingEmail.text = ""
        self.shippingPhone.text = ""
        
        AddressData.sharedInstance.setBillingAddress(self.billTo)
        AddressData.sharedInstance.setShippingAddress(self.shipTo)
    }
    
    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
