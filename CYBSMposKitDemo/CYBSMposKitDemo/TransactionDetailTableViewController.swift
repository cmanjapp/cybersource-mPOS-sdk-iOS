//
//  TransactionDetailTableViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 7/29/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class TransactionDetailTableViewController: UITableViewController, CYBSMposManagerDelegate {

  @IBOutlet var spinner: UIActivityIndicatorView!

    let sections = ["Transaction Info", "Payment Info", "Actions", "Events", "Signature"]
    let numberOfRowsInSection = [12, 7, 0, 0, 1]
    let actions: [CYBSMposTransactionType: [CYBSMposTransactionActionType]] = [
    .authorization: [.sendReceipt, .capture, .reverse],
    .capture: [.sendReceipt, .void, .refund, .partialRefund],
    .sale: [.sendReceipt, .void, .refund, .partialRefund],
    .refund: [.void]
  ]

  let dateFormatter = DateFormatter()

  var transaction: CYBSMposTransaction?
  var events: [CYBSMposTransaction] = []
  var transactionReady = false
  var gotAllEvents = false
  var signatureData = Data()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

    if !transactionReady {
      spinner.color = UIColor.gray

      let navigationBarHeight = self.navigationController!.navigationBar.frame.size.height
      let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
      spinner.center = CGPoint(x: self.view.frame.size.width / 2.0, y: (self.view.frame.size.height  - navigationBarHeight - tabBarHeight) / 2.0);

      view.addSubview(spinner)

      spinner.hidesWhenStopped = true

      view.isUserInteractionEnabled = false
      spinner.startAnimating()

      Utils.createAccessToken { (accessToken, error) in
        let manager = Utils.getManager()
        print("CreateAccessToken invoked to get transaction details", accessToken ?? "access token empty", self.transaction!.transactionID)
        manager.getTransactionDetail(self.transaction!.transactionID, accessToken: accessToken!, delegate: self)
      }
    }
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section]
  }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 4 {
//            return 100
//        } else {
//            return 44
//        }
        
        return UITableViewAutomaticDimension
    }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = numberOfRowsInSection[section]
    if numberOfRows == 0 {
      if let transaction = self.transaction {
        if section == 2 {
          if let actions = actions[transaction.transactionType] {
            numberOfRows = actions.count
          }
        } else if section == 3 {
          if gotAllEvents {
            numberOfRows = events.count
          } else if transaction.events?.count > 0 {
            numberOfRows = 1
          }
        }
      }
    }
    return numberOfRows
  }

  func createTransactionInfoCell(_ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCell", for: indexPath) as! DetailCell

    cell.detailLabel!.text = ""

    switch (indexPath as NSIndexPath).row {
    case 0:
      cell.titleLabel!.text = "Transaction ID"
      if let transaction = self.transaction {
        cell.detailLabel!.text = transaction.transactionID
      }
    case 1:
      cell.titleLabel!.text = "Transaction Date"
      if let transaction = self.transaction {
        cell.detailLabel!.text = dateFormatter.string(from: transaction.transactionDate)
      }
    case 2:
      cell.titleLabel!.text = "Transaction Type"
      if let transaction = self.transaction {
        switch (transaction.transactionType) {
        case .authorization:
          cell.detailLabel!.text = "Authorization"
        case .capture:
          cell.detailLabel!.text = "Capture"
        case .sale:
          cell.detailLabel!.text = "Sale"
        case .refund:
          cell.detailLabel!.text = "Refund"
        case .reversal:
          cell.detailLabel!.text = "Reversal"
        case .void:
          cell.detailLabel!.text = "Void"
        case .metadata:
          cell.detailLabel!.text = "Metadata"
        default:
          cell.detailLabel!.text = "Undefined"
        }
      }
    case 3:
      cell.titleLabel!.text = "Currency"
      if let transaction = self.transaction {
        cell.detailLabel!.text = transaction.currency
      }
    case 4:
      cell.titleLabel!.text = "Amount"
      if let amount = self.transaction?.amount {
        cell.detailLabel!.text = NSString(format:"%@%.2f", getCurrencySymbol(code: self.transaction?.currency ?? "USD"), amount.doubleValue) as String
      }
    case 5:
      cell.titleLabel!.text = "Merchant Reference Code"
      if let transaction = self.transaction {
        cell.detailLabel!.text = transaction.merchantReferenceCode
      }
    case 6:
      cell.titleLabel!.text = "Transaction Reference No"
      if let transaction = self.transaction {
        cell.detailLabel!.text = transaction.transRefNo
      }
    case 7:
      cell.titleLabel!.text = "Authorization Code"
      if let transaction = self.transaction {
        cell.detailLabel!.text = transaction.authCode
      }
    case 8:
      cell.titleLabel!.text = "Reason Code"
      if let transaction = self.transaction , transaction.reasonCode != 0 {
        cell.detailLabel!.text = String(transaction.reasonCode)
      }
    case 9:
      cell.titleLabel!.text = "Reply Message"
      if let transaction = self.transaction {
        cell.detailLabel!.text = transaction.replyMessage
      }
    case 10:
      cell.titleLabel!.text = "Request Token"
      if let transaction = self.transaction {
        cell.detailLabel!.text = transaction.requestToken
      }
    case 11:
      cell.titleLabel!.text = "Status"
      if let transaction = self.transaction {
        cell.detailLabel!.text = transaction.status
      }
    default:
      break
    }

    return cell
  }

  func createPaymentInfoCell(_ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCell", for: indexPath) as! DetailCell

    cell.detailLabel!.text = ""

    switch (indexPath as NSIndexPath).row {
    case 0:
      cell.titleLabel!.text = "Payment Type"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailLabel!.text = paymentInfo.paymentType
      }
    case 1:
      cell.titleLabel!.text = "Full Name"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailLabel!.text = paymentInfo.fullName
      }
    case 2:
      cell.titleLabel!.text = "Account Suffix"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailLabel!.text = paymentInfo.accountSuffix
      }
    case 3:
      cell.titleLabel!.text = "Expiration Month"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailLabel!.text = paymentInfo.expirationMonth
      }
    case 4:
      cell.titleLabel!.text = "Expiration Year"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailLabel!.text = paymentInfo.expirationYear
      }
    case 5:
      cell.titleLabel!.text = "Card Type"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailLabel!.text = paymentInfo.cardType
      }
    case 6:
      cell.titleLabel!.text = "Processor"
      if let paymentInfo = self.transaction?.paymentInfo {
        cell.detailLabel!.text = paymentInfo.processor
      }
    default:
      break
    }

    return cell
  }

  func canRefund() -> Bool {
    if let transaction = self.transaction  , transactionReady && !transaction.error {
      switch transaction.transactionType {
      case .capture, .sale:
        if (transaction.status == "PENDING" || transaction.status == "TRANSMITTED") &&
          ((transaction.actions & CYBSMposTransactionActionType.refund.rawValue) == CYBSMposTransactionActionType.refund.rawValue) {
          if gotAllEvents && !events.isEmpty {
            var refundAmount = 0.0
            for event in events {
              if event.transactionType == .refund {
                refundAmount += event.amount?.doubleValue ?? 0.0
              }
            }
            if refundAmount < transaction.amount?.doubleValue {
              return true
            }
          }
        }
      default:
        break
      }
    }
    return false
  }

  func canReverse() -> Bool {
    if let transaction = self.transaction , transactionReady && !transaction.error {
      switch transaction.transactionType {
      case .authorization:
        if (transaction.actions & CYBSMposTransactionActionType.reverse.rawValue) == CYBSMposTransactionActionType.reverse.rawValue {
          return true
        }
      default:
        break
      }
    }
    return false
  }
    
    func canCapture() -> Bool {
        if let transaction = self.transaction , transactionReady && !transaction.error {
            switch transaction.transactionType {
            case .authorization, .sale:
                if (transaction.actions & CYBSMposTransactionActionType.capture.rawValue) == CYBSMposTransactionActionType.capture.rawValue {
                    return true
                }
            default:
                break
            }
        }
        return false
    }

  func canVoid() -> Bool {
    if let transaction = self.transaction , transactionReady && !transaction.error {
      switch transaction.transactionType {
      case .capture, .sale, .refund:
        if transaction.status == "PENDING" {
          return true
        }
      default:
        break
      }
    }
    return false
  }

  func canSendReceipt() -> Bool {
    if let transaction = self.transaction , transactionReady && !transaction.error {
      switch transaction.transactionType {
      case .capture, .sale:
        return true
      case .authorization:
        if transaction.amount?.floatValue > 0 {
            return true
        }
      default:
        break
      }
    }
    return false
  }

  func createActionCell(_ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionActionCell", for: indexPath) as! TransactionActionCell

    cell.button.isEnabled = false

    switch actions[transaction!.transactionType]![(indexPath as NSIndexPath).row] {
    case .capture:
        cell.button.setTitle("Capture", for: UIControlState())
        cell.button.isEnabled = canCapture()
        cell.button.tag = Int(CYBSMposTransactionActionType.capture.rawValue)
    case .refund:
      cell.button.setTitle("Refund", for: UIControlState())
      cell.button.isEnabled = canRefund()
      cell.button.tag = Int(CYBSMposTransactionActionType.refund.rawValue)
    case .reverse:
      cell.button.setTitle("Reverse", for: UIControlState())
      cell.button.isEnabled = canReverse()
      cell.button.tag = Int(CYBSMposTransactionActionType.reverse.rawValue)
    case .void:
      cell.button.setTitle("Void", for: UIControlState())
      cell.button.isEnabled = canVoid()
      cell.button.tag = Int(CYBSMposTransactionActionType.void.rawValue)
    case .sendReceipt:
      cell.button.setTitle("Send Receipt", for: UIControlState())
      cell.button.isEnabled = canSendReceipt()
      cell.button.tag = Int(CYBSMposTransactionActionType.sendReceipt.rawValue)
    case .partialRefund:
        cell.button.setTitle("Partial Refund", for: UIControlState())
        cell.button.isEnabled = canRefund()
        cell.button.tag = Int(CYBSMposTransactionActionType.partialRefund.rawValue)
    default:
      break
    }

    return cell
  }

  func createEventCell(_ indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionEventCell", for: indexPath) as! HistoryTableViewCell

    let transaction = events[(indexPath as NSIndexPath).row]

    cell.transactionDateLabel.text = self.dateFormatter.string(from: transaction.transactionDate)
    cell.transactionIDLabel.text = transaction.transactionID

    if let info = transaction.paymentInfo {
      var paymentInfo = String()
      if info.cardType == "Visa" {
        cell.paymentTypeImage.image = UIImage(named: "VisaLogo")
      } else if info.cardType == "MasterCard" {
        cell.paymentTypeImage.image = UIImage(named: "MasterCardLogo")
      } else if info.cardType == "American Express" {
        cell.paymentTypeImage.image = UIImage(named: "AmericanExpressLogo")
      } else if info.cardType == "Discover" {
        cell.paymentTypeImage.image = UIImage(named: "DiscoverLogo")
      } else {
        cell.paymentTypeImage.image = UIImage()
        paymentInfo += info.cardType ?? ""
      }

      if let accountSuffix = info.accountSuffix {
        paymentInfo += " " + accountSuffix
      }

      if let fullName = info.fullName {
        paymentInfo += " " + fullName
      }

      cell.paymentInfoLabel.text = paymentInfo
    }

    cell.merchantReferenceCodeLabel.text = transaction.merchantReferenceCode ?? ""
    cell.amountLabel.text = transaction.amount != nil ? NSString(format:"%@%.2f", getCurrencySymbol(code: self.transaction?.currency ?? "USD"), transaction.amount!.doubleValue) as String : ""

    switch (transaction.transactionType) {
    case .authorization:
      cell.transactionTypeLabel.text = "Authorization"
    case .capture:
      cell.transactionTypeLabel.text = "Capture"
    case .sale:
      cell.transactionTypeLabel.text = "Sale"
    case .refund:
      cell.transactionTypeLabel.text = "Refund"
    case .reversal:
      cell.transactionTypeLabel.text = "Reversal"
    case .void:
      cell.transactionTypeLabel.text = "Void"
    case .metadata:
      cell.transactionTypeLabel.text = "Metadata"
    default:
      cell.transactionTypeLabel.text = "Undefined"
    }

    if transaction.error {
      cell.transactionTypeLabel.textColor = UIColor.red
    } else {
      cell.transactionTypeLabel.textColor = nil;
    }

    if transaction.transactionID == self.transaction?.transactionID || (self.transaction?.status == "PENDING" || self.transaction?.status == "TRANSMITTED") {
      cell.accessoryType = .checkmark
      cell.selectionStyle = .none
    } else {
      cell.accessoryType = .disclosureIndicator
      cell.selectionStyle = .default
    }

    return cell
  }

    func createSignatureCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionSignatureCell", for: indexPath) as! TransactionSignatureCell
        
        cell.signatureImageView.image = UIImage(data: self.signatureData)
        return cell
    }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (indexPath as NSIndexPath).section == 0 {
      return createTransactionInfoCell(indexPath)
    } else if (indexPath as NSIndexPath).section == 1 {
      return createPaymentInfoCell(indexPath)
    } else if (indexPath as NSIndexPath).section == 2 {
      return createActionCell(indexPath)
    } else if (indexPath as NSIndexPath).section == 3 && gotAllEvents {
      return createEventCell(indexPath)
    } else if (indexPath as NSIndexPath).section == 4 {
        return createSignatureCell(indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
      let activityIndicator = cell.contentView.viewWithTag(100) as! UIActivityIndicatorView
      activityIndicator.startAnimating()
      return cell
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath as NSIndexPath).section == 3 {
      let cell = tableView.cellForRow(at: indexPath)
      if cell?.accessoryType == .disclosureIndicator {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailTableViewController") as! TransactionDetailTableViewController
        controller.transaction = events[(indexPath as NSIndexPath).row]
        controller.transactionReady = true
        controller.events = events
        controller.gotAllEvents = true
        self.navigationController?.pushViewController(controller, animated: true)
      }
    }
  }

  func sendReceipt() {
    self.spinner.startAnimating()

    let alertController = UIAlertController(title: "Receipt",
                                            message: "Please enter the email address to receive an electronic receipt.",
                                            preferredStyle: .alert)
    alertController.addTextField(configurationHandler: { (textField) in
      textField.placeholder = "Customer E-mail Address"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        self.spinner.stopAnimating()
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
      Utils.createAccessToken { (accessToken, error) in

        let manager = Utils.getManager()

        let receiptRequest = CYBSMposReceiptRequest(transactionID: self.transaction!.transactionID,
                                                          toEmail: alertController.textFields![0].text!,
                                                      accessToken: accessToken!)

        manager.sendReceipt(receiptRequest, delegate: self)
      }
    }
    alertController.addAction(doneAction)
    self.present(alertController, animated: true) {
    }
  }

    func capture(){
        self.spinner.startAnimating()

        let alertController = UIAlertController(title: "Capture",
                                                message: "Do you want to capture this transaction?",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            Utils.createAccessToken { (accessToken, error) in
                let merchantID = Settings.sharedInstance.merchantID ?? ""
                
                let manager = Utils.getManager()
                let captureRequest = CYBSMposCaptureRequest(merchantID: merchantID, accessToken: accessToken!,
                                                          merchantReferenceCode: self.transaction!.merchantReferenceCode!, transactionID: self.transaction!.transactionID,
                                                          currency: self.transaction!.currency!, amount: self.transaction!.amount!)
                
                manager.performCapture(captureRequest, delegate: self)
            }
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true) {
        }
    }
    
    func authorizationReversal() {
        self.spinner.startAnimating()
        
        let alertController = UIAlertController(title: "Authorization Reversal",
                                                message: "Do you want to reverse this authorization?",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            Utils.createAccessToken { (accessToken, error) in
                let merchantID = Settings.sharedInstance.merchantID ?? ""
                
                let manager = Utils.getManager()
                
                let authReversalRequest = CYBSMposAuthorizationReversalRequest(merchantID: merchantID, accessToken: accessToken!,
                                                            merchantReferenceCode: self.transaction!.merchantReferenceCode!, transactionID: self.transaction!.transactionID,
                                                            currency: self.transaction!.currency!, amount: self.transaction!.amount!)
                
                manager.performAuthorizationReversal(authReversalRequest, delegate: self)
            }
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true) {
        }
    }

  func refund() {
    self.spinner.startAnimating()

    let alertController = UIAlertController(title: "Refund",
                                            message: "Do you want to refund this transaction?",
                                            preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
      Utils.createAccessToken { (accessToken, error) in
        let merchantID = Settings.sharedInstance.merchantID ?? ""

        let manager = Utils.getManager()

        let refundRequest = CYBSMposRefundRequest(merchantID: merchantID, accessToken: accessToken!,
          merchantReferenceCode: self.transaction!.merchantReferenceCode!, transactionID: self.transaction!.transactionID,
          currency: self.transaction!.currency!, amount: self.transaction!.amount!)

        manager.performRefund(refundRequest, delegate: self)
      }
    }
    alertController.addAction(doneAction)
    self.present(alertController, animated: true) {
    }
  }
    
    func decimal(with string: String) -> NSDecimalNumber {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: string) as? NSDecimalNumber ?? 0
    }
    
    func partialRefund() {
            let alertController = UIAlertController(title: "Partial Refund",
                                                    message: "Enter the amount for partial refund",
                                                    preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Amount"
                textField.keyboardType = .decimalPad
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
                Utils.createAccessToken { (accessToken, error) in
                    if (error != nil) {
                        self.spinner.stopAnimating()
                    }
                    let merchantID = Settings.sharedInstance.merchantID ?? ""
                    let manager = Utils.getManager()
                    let amount = self.decimal(with: alertController.textFields![0].text!)

                    let refundRequest = CYBSMposRefundRequest(merchantID: merchantID, accessToken: accessToken!,
                                                              merchantReferenceCode: self.transaction!.merchantReferenceCode!, transactionID: self.transaction!.transactionID,
                                                              currency: self.transaction!.currency!, amount: amount)
                    
                    manager.performRefund(refundRequest, delegate: self)
                }
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true) {
            }
    }

  func void() {
    self.spinner.startAnimating()

    let alertController = UIAlertController(title: "Void",
                                            message: "Do you want to void this transaction?",
                                            preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
      Utils.createAccessToken { (accessToken, error) in
        let merchantID = Settings.sharedInstance.merchantID ?? ""

        let manager = Utils.getManager()

        let voidRequest = CYBSMposVoidRequest(merchantID: merchantID, accessToken: accessToken!,
          merchantReferenceCode: self.transaction!.merchantReferenceCode!, transactionID: self.transaction!.transactionID)

        manager.performVoid(voidRequest, delegate: self)
      }
    }
    alertController.addAction(doneAction)
    self.present(alertController, animated: true) {
    }
  }

    func getTransactionDetailDidFinish(_ transaction: CYBSMposTransaction?, error: Error?) {
        if  let transaction = transaction {
            if !transactionReady {
                spinner.stopAnimating()
                view.isUserInteractionEnabled = true
                self.transaction = transaction
                transactionReady = true
                tableView.reloadData()
                
                if let events = transaction.events {
                    if !events.isEmpty {
                        DispatchQueue.main.async(execute: {
                            Utils.createAccessToken { (accessToken, error) in
                                let manager = Utils.getManager()
                                manager.getTransactionDetail((events[0] as AnyObject).transactionID, accessToken: accessToken!, delegate: self)
                            }
                        })
                    }
                }
            } else {
                events.append(transaction)
                if events.count < self.transaction!.events!.count {
                    DispatchQueue.main.async(execute: {
                        Utils.createAccessToken { (accessToken, error) in
                            let manager = Utils.getManager()
                            manager.getTransactionDetail((self.transaction!.events![self.events.count] as AnyObject).transactionID, accessToken: accessToken!, delegate: self)
                        }
                    })
                } else {
                    var ids = Set<String>()
                    var removeDuplicated: [CYBSMposTransaction] = []
                    for event in events {
                        if !ids.contains(event.transactionID) {
                            ids.insert(event.transactionID)
                            removeDuplicated.append(event)
                        }
                    }
                    events = removeDuplicated
                    gotAllEvents = true
                    
                    //Always get the signature at the end, after all the events
                    DispatchQueue.main.async(execute: {
                        Utils.createAccessToken { (accessToken, error) in
                            let manager = Utils.getManager()
                            manager.getTransactionSignature(transaction.transactionID, accessToken: accessToken!, delegate: self)
                        }
                    })
                    tableView.reloadData()
                }
            }
        }else{
            spinner.stopAnimating()
        }
    }

    func getTransactionSignatureDidFinish(_ signature: Data?, error: Error?) {
        if signature != nil {
            self.signatureData = signature!
            spinner.stopAnimating()
            view.isUserInteractionEnabled = true
            tableView.reloadData()
        } else {
            spinner.stopAnimating()
        }
    }

    func performVoidDidFinish(_ result: CYBSMposPaymentResponse?, error: Error?) {
        self.spinner.stopAnimating()
        
        print("performVoidDidFinish")
        if let error = error {
            print("Received void error: \(error.localizedDescription)")
        }
        
        if (result?.reasonCode == "100") {
            let alertController = UIAlertController(title: "Void",
                                                    message: "Successfully voided this transaction.",
                                                    preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true) {
            }
        } else {
            let alertController = UIAlertController(title: "Void",
                                                    message: "Failed to void this transaction.",
                                                    preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true) {
            }
        }
    }
    
    func performRefundDidFinish(_ result: CYBSMposPaymentResponse?, error: Error?) {
        self.spinner.stopAnimating()
        
        print("performRefundDidFinish")
        if (result?.reasonCode == "100") {
            let alertController = UIAlertController(title: "Refund",
                                                    message: "Successfully refunded this transaction.",
                                                    preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true) {
            }
        } else {
            let alertController = UIAlertController(title: "Refund",
                                                    message: "Failed to refund this transaction.",
                                                    preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true) {
            }
        }
    }

    func performCaptureDidFinish(_ result: CYBSMposPaymentResponse?, error: Error?) {
        self.spinner.stopAnimating()
        
        print("performCaptureDidFinish")
        if (result?.reasonCode == "100") {
            let alertController = UIAlertController(title: "Capture",
                                                    message: "Successfully captured this transaction.",
                                                    preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true) {
            }
        } else {
            let alertController = UIAlertController(title: "Capture",
                                                    message: "Failed to capture this transaction.",
                                                    preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true) {
            }
        }
    }
    
    func performAuthorizationReversalDidFinish(_ result: CYBSMposPaymentResponse?, error: Error?) {
        self.spinner.stopAnimating()
        
        print("performAuthorizationReversalDidFinish")
        if (result?.reasonCode == "100") {
            let alertController = UIAlertController(title: "Authorization Reversal",
                                                    message: "Successfully reversed this transaction.",
                                                    preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true) {
            }
        } else {
            let alertController = UIAlertController(title: "Authorization Reversal",
                                                    message: "Failed to reverse this transaction.",
                                                    preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true) {
            }
        }
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
    
  @IBAction func buttonClicked(_ button: UIButton) {
    if button.tag == Int(CYBSMposTransactionActionType.refund.rawValue) {
      refund()
    } else if button.tag == Int(CYBSMposTransactionActionType.void.rawValue) {
      void()
    } else if button.tag == Int(CYBSMposTransactionActionType.sendReceipt.rawValue) {
      sendReceipt()
    } else if button.tag == Int(CYBSMposTransactionActionType.capture.rawValue) {
        capture()
    } else if button.tag == Int(CYBSMposTransactionActionType.reverse.rawValue) {
        authorizationReversal()
    }
    else if button.tag == Int(CYBSMposTransactionActionType.partialRefund.rawValue) {
        partialRefund()
    }
  }

}
