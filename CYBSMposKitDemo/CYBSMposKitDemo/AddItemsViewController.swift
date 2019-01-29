//
//  AddItemsViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 11/28/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import UIKit

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
    
    func backToInitial(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
        self.delegate?.addItemsDidFinish(addItemsViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(self.backToInitial(sender:)))
        // Do any additional setup after loading the view.
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
    
    func populateTable() {
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        self.itemsTableView.setEditing(true, animated: false)
        self.calculateSubtotalAndItemCount()
    }
    
    func calculateSubtotalAndItemCount() {
        var finalTotal:Float = 0.0
        let cart = CartData.sharedInstance
        for item in cart.items {
            var subTotal:Float = 0.0
            subTotal = subTotal.adding(Float(item.itemizedAmount))
            subTotal = subTotal.multiplied(by: Float(item.itemQuantity!))
            
            finalTotal = finalTotal + subTotal
        }
        self.subTotalLabel.text = String(format: "%.2f", finalTotal)
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
