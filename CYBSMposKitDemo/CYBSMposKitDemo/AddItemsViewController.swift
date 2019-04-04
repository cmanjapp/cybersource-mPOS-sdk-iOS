//
//  AddItemsViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 11/28/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import UIKit

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class cartItem: NSObject {
    var itemName:String?
    var itemQuantity:NSInteger?
    var itemizedAmount:NSDecimalNumber
    
    override init() {
        itemName = nil
        itemQuantity = 0
        itemizedAmount = 0.0
    }
}


class CartData: NSObject {
    var items = Array<cartItem>()
    
    var grandTotalAmount:Double = 0.0
    var subTotalAmount:Double = 0.0
    var taxTotalAmount:Double = 0.0
    var tipAmount:Double = 0.0

    static var sharedInstance = CartData()
    private override init() {
    }
    
}

protocol AddItemsViewControllerDelegate {
    func addItemsDidFinish(addItemsViewController:AddItemsViewController)
}


class AddItemsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ItemCellProtocol {
    
    var delegate:AddItemsViewControllerDelegate?
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var taxAmountLabel: UILabel!
    @IBOutlet weak var tipAmountTextField: UITextField!
    @IBOutlet weak var tipAmountLabel: UILabel!

    @IBAction func continueBtnAction(_ sender: Any) {
        if Settings.sharedInstance.tipEnabled == true {
            self.showTipAlert()
        }
        else {
            self.navigationController?.popToRootViewController(animated: true)
            self.delegate?.addItemsDidFinish(addItemsViewController: self)
        }
    }
    
    func backToInitial(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
        self.delegate?.addItemsDidFinish(addItemsViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(self.backToInitial(sender:)))
        // Do any additional setup after loading the view.
        
        self.navigationItem.hidesBackButton = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        populateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTipAlert(){
        let alertController = UIAlertController(title: "Tip",
                                                message: "Please enter the tip amount.",
                                                preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Tip Amount"
            textField.keyboardType = .decimalPad
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.backToInitial(sender: alertController)
        }
        alertController.addAction(cancelAction)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            
            if let tip =  alertController.textFields![0].text {
                let tipAmount: Double  = Double(tip) ?? 0.0
                self.tipAmountTextField.text = String(format: "%.2f", tipAmount)
                CartData.sharedInstance.tipAmount = tipAmount
                self.calculateSubtotalAndItemCount()
            }
            self.backToInitial(sender: alertController)
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true) {
        }
    }
    
    func populateTable() {
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        self.itemsTableView.setEditing(true, animated: false)
        if Settings.sharedInstance.tipEnabled == false {
            CartData.sharedInstance.tipAmount = 0.0
            self.tipAmountLabel.isHidden = true
            self.tipAmountTextField.isHidden = true
        }
        else {
            self.tipAmountLabel.isHidden = false
            self.tipAmountTextField.isHidden = false
        }
        self.calculateSubtotalAndItemCount()
        self.tipAmountTextField.text = String(format: "%.2f", CartData.sharedInstance.tipAmount)

    }
    
//    func roundDecimal(number:NSDecimalNumber) -> NSDecimalNumber {
//        
//        let roundedValue = number.rounding(accordingToBehavior: behavior)
//        return roundedValue
//    }
    
    
    public func calcCost() -> (subTotal: Double, tax: Double, grandTotal: Double) {
        var subTotal: NSDecimalNumber = NSDecimalNumber.zero
        var taxAmount: NSDecimalNumber = NSDecimalNumber.zero
        var grandTotal: NSDecimalNumber = NSDecimalNumber.zero
        let scale: Int16 = 2
        
        let behavior = NSDecimalNumberHandler(roundingMode: .plain, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)

        
        let cart = CartData.sharedInstance
        for item in cart.items {
            var itemTotal:NSDecimalNumber = NSDecimalNumber.zero
            var itemTax:NSDecimalNumber = NSDecimalNumber.zero

            itemTotal = itemTotal.adding(item.itemizedAmount)
            itemTotal = itemTotal.multiplying(by: NSDecimalNumber(value: item.itemQuantity!), withBehavior: behavior)
            if (Settings.sharedInstance.taxEnabled == true) {
                if let tax = Settings.sharedInstance.taxRate {
                    let taxDouble = Double(tax)
                    let taxRate = (taxDouble ?? 8.25 )/100.00
                    //taxAmount =  subTotal * taxRate
                    itemTax = itemTotal.multiplying(by: NSDecimalNumber(value: taxRate), withBehavior: behavior)
                    taxAmount = taxAmount.adding(itemTax)
                }
            }
            subTotal = subTotal.adding(itemTotal)
        }
        
        grandTotal = subTotal.adding(taxAmount)
        // Done if no product selection
        
        return (subTotal.doubleValue, taxAmount.doubleValue, grandTotal.doubleValue)
    }
    
    func calculateSubtotalAndItemCount() {
        let cost = self.calcCost()
        var grandTotal =  cost.grandTotal
        if Settings.sharedInstance.tipEnabled == true {
            grandTotal = cost.grandTotal + CartData.sharedInstance.tipAmount
        }
        self.subTotalLabel.text = String(format: "%.2f", cost.subTotal)
        self.grandTotalLabel.text = String(format: "%.2f", grandTotal)
        self.taxAmountLabel.text = String(format: "%.2f", cost.tax)
        
        
        CartData.sharedInstance.grandTotalAmount = grandTotal
        CartData.sharedInstance.subTotalAmount = cost.subTotal
        CartData.sharedInstance.taxTotalAmount = cost.tax

        
    }

    
    @IBAction func addItem(_ sender: Any) {
        let item = cartItem()
        item.itemQuantity = 1;
        item.itemName = "Goods/Services"
        item.itemizedAmount = 1.0
        let cart = CartData.sharedInstance
        cart.items.append(item)
        self.itemsTableView.insertRows(at: [IndexPath(row: cart.items.count-1, section: 0)], with: .automatic)
        self.calculateSubtotalAndItemCount()
    }
    
    
    @IBAction func clearAll(_ sender: Any) {
        CartData.sharedInstance.items.removeAll()
        CartData.sharedInstance.tipAmount = 0.0
        self.itemsTableView.reloadData()
        self.calculateSubtotalAndItemCount()
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeItemAt(indexPath: indexPath as NSIndexPath)
        } else if (editingStyle == .insert) {
            self.addItem(self)
        }
    }
    
    func removeItemAt(indexPath: NSIndexPath) {
        if (CartData.sharedInstance.items.count > indexPath.row) {
            CartData.sharedInstance.items.remove(at: indexPath.row)
            self.itemsTableView.reloadData()
            self.calculateSubtotalAndItemCount()
        }
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        
        if (textField.tag == 20) {
            if (textField.text?.count == 31 && !(string == "")) {
                return false
            }  else {
                return true
            }
        } else if (textField.tag == 31) {
            let isDelete = string.isEmpty
            if !isDelete {
                let num = Int(string)
                if num == nil {
                    return false
                }
            }
            let count:Int = (textField.text?.count)!
            if ((count >= 2) && string.count != 0) {
                return false
            } else {
                return true
            }
        } else if (textField.tag == 0) {
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
                        let num = Int(string)
                        if ((num == nil) && (string != ".")) {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField, forCell: Any) {
        let indexPath = self.itemsTableView.indexPath(for: forCell as! UITableViewCell)
        if (indexPath == nil) {
            return
        }
        let cart = CartData.sharedInstance
        if (textField.tag == 20) {
            if (cart.items.count >= (indexPath?.row)!) {
                let itemDetails = cart.items[(indexPath?.row)!]
                if ((textField.text?.count) != nil) {
                    itemDetails.itemName = textField.text
                } else {
                    itemDetails.itemName = "Goods/Services"
                }
            }
        } else if (textField.tag == 31) {
            if (textField.text?.count == 0 ) {
                textField.text = "1"
            }
            if (cart.items.count >= (indexPath?.row)!) {
                let itemDetails = cart.items[(indexPath?.row)!]
                itemDetails.itemQuantity = Int(textField.text!)
                self.itemsTableView.beginUpdates()
                if (itemDetails.itemQuantity == 0) {
                    cart.items.remove(at: (indexPath?.row)!)
                    self.itemsTableView.deleteRows(at: [indexPath!], with: .automatic)
                } else {
                    self.itemsTableView.reloadRows(at: [indexPath!], with: .none)
                }
                self.itemsTableView.endUpdates()
                self.calculateSubtotalAndItemCount()
            }
        } else if (textField.tag == 0) {
            if (textField.text?.count == 0 ) {
                textField.text = "1.00"
            }
            if (cart.items.count >= (indexPath?.row)!) {
                let itemDetails = cart.items[(indexPath?.row)!]
                itemDetails.itemizedAmount = NSDecimalNumber(string: textField.text!)
                self.itemsTableView.reloadRows(at: [indexPath!], with: .none)
                self.calculateSubtotalAndItemCount()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartData.sharedInstance.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cart = CartData.sharedInstance
        let itemInfo = cart.items[indexPath.row]
        let itemCell = self.itemsTableView.dequeueReusableCell(withIdentifier: "item") as! ItemCell
        itemCell.delegate = self;
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        itemCell.amountTextField.text = formatter.string(from: itemInfo.itemizedAmount)
        //itemCell.amountTextField.delegate = self
        itemCell.quantity.text = String(format: "%d", itemInfo.itemQuantity!)
        itemCell.descriptionTextField.text = itemInfo.itemName
        return itemCell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
