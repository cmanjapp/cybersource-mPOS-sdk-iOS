//
//  EnterKeyedInDetailsViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 12/5/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import UIKit

@objc protocol MonthYearPickerViewProtocol {
    @objc optional func continueTransaction(cardData: CYBSMposCardDataManual?)
}

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    var months: [String]!
    var years: [Int]!

    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...25 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0)+1
        let year = years[self.selectedRow(inComponent: 1)]
        if let block = onDateSelected {
            block(month, year)
        }
        self.month = month
        self.year = year
    }
    
}

class EnterKeyedInDetailsViewController: UITableViewController,CYBSMposManagerDelegate,UITextFieldDelegate {
    

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var securityCodeTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    weak var myDelegate:MonthYearPickerViewProtocol?

    var transactionRequest:CYBSMposPaymentRequest?
    var transactionResponse:CYBSMposPaymentResponse?
    var manager:CYBSMposManager!
    
    var amount:String?
    var requiredFields:Array<Any>?
    var cardNumber = ""
    var securityCode = ""
    var merchantRefCode:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currency = Settings.sharedInstance.currency?.uppercased()
        if (currency ?? "").isEmpty {
            currency = "USD"
        }
        self.amountLabel.text = String(format:"%@%@",self.getSymbol(forCurrencyCode: currency!)!,self.amount!)
        
        let expiryDatePicker = MonthYearPickerView()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            self.expirationDateTextField.text = string
            self.checkRequiredFields()
            NSLog(string) // should show something like 05/2015
        }
        self.expirationDateTextField.inputView = expiryDatePicker
        
        self.nameTextField.delegate = self
        self.cardNumberTextField.delegate = self
        self.securityCodeTextField.delegate = self
        self.postalCodeTextField.delegate = self
        
        self.requiredFields = [self.nameTextField, self.cardNumberTextField, self.expirationDateTextField, self.securityCodeTextField, self.postalCodeTextField]
        self.view.addSubview(self.spinner)
        self.spinner.hidesWhenStopped = true;
        
        self.manager = Utils.getManager()
        self.manager.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }

    func checkRequiredFields() {
        for var field in self.requiredFields! {
            if (field as! UITextField).text?.count == 0 {
                self.nextButton.isEnabled = false
                return
            }
        }
        self.nextButton.isEnabled = true
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNumberTextField {
            var num = Int(string)
            if (string.count > 0 && num == nil) {
                return false;
            }
            if string.count > 0 {
                if self.cardNumber.count == 16 {
                    return false;
                }
                self.cardNumber = self.cardNumber + string
            } else if self.cardNumber.count > 0 {
                self.cardNumber = (self.cardNumber as NSString).substring(to: (self.cardNumber.count) - 1)
            }
            var masked = ""
            if (cardNumber.count != 0) {
                for var i in 0..<(self.cardNumber.count) {
                    if i>0 && i%4==0 {
                        masked = masked + " "
                    }
                    let ind = self.cardNumber.index((self.cardNumber.startIndex), offsetBy: i)
                    //masked?.appendFormat("%c", String(self.cardNumber[ind]))
                    masked = masked + String(self.cardNumber[ind])
                }
            }
            self.cardNumberTextField.text = masked as String?
            self.checkRequiredFields()
            return false
        } else if (textField == self.securityCodeTextField) {
            var num = Int(string)
            if ((string.count > 0) && (num == nil)) {
                return false;
            }
            if (((self.securityCode.count) + string.count) <= 3 ) {
                if (string.count > 0 ) {
                    self.securityCode = self.securityCode + string
                } else if self.securityCode.count > 0 {
                    self.securityCode = (self.securityCode as NSString).substring(to: (self.securityCode.count) - 1)
                }
                self.securityCodeTextField.text = self.securityCode
            }
            self.checkRequiredFields()
            return false
        } else if textField == self.postalCodeTextField {
            
        }
        if (string.count > 0) {
            textField.text = textField.text! + string
        } else if (textField.text?.count as! Int > 0) {
            textField.text = (textField.text as! NSString).substring(to: (textField.text?.count)!-1)
        }
        self.checkRequiredFields()
        return false
    }
    
    @IBAction func doKeyedInTransaction(_ sender: Any) {
        let zipCode = self.postalCodeTextField.text
        let cardData = CYBSMposCardDataManual();
        let exp = self.expirationDateTextField.text
        let components = exp?.components(separatedBy: "/");
        
        cardData.accountNumber = self.cardNumber;
        cardData.expirationMonth = components![0];
        cardData.expirationYear = components![1];
        
        cardData.cvNumber = self.securityCodeTextField.text;
        cardData.zipCode = zipCode!
        cardData.cardName = self.nameTextField.text

        self.myDelegate?.continueTransaction!(cardData: cardData)
        self.navigationController?.popViewController(animated: true)
    }
}

