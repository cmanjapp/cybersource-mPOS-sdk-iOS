//
//  HistoryTableViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 7/6/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, CYBSMposManagerDelegate {

  @IBOutlet var spinner: UIActivityIndicatorView!

  let dateFormatter = DateFormatter()
  let transactions = NSMutableArray()

  var query = CYBSMposTransactionSearchQuery()
  var didRefresh = false
  var result: CYBSMposTransactionSearchResult? = nil

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))

    self.refreshControl = UIRefreshControl()
    self.refreshControl?.backgroundColor = UIColor.white
    self.refreshControl?.tintColor = UIColor.gray
    self.refreshControl?.addTarget(self, action: #selector(HistoryTableViewController.refresh), for: UIControl.Event.valueChanged)

    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

    spinner.color = UIColor.gray

    let navigationBarHeight = self.navigationController!.navigationBar.frame.size.height
    let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
    spinner.center = CGPoint(x: self.view.frame.size.width / 2.0, y: (self.view.frame.size.height  - navigationBarHeight - tabBarHeight) / 2.0);

    view.addSubview(spinner)

    spinner.hidesWhenStopped = true
    spinner.startAnimating()

    getHistory()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let result = self.result {
      if (self.transactions.count == result.total) {
        return transactions.count
      } else {
        return transactions.count + 1
      }
    }
    return transactions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if !(self.spinner.isAnimating) && (self.transactions.count > 0) && ((indexPath as NSIndexPath).row == self.transactions.count) {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
      let activityIndicator = cell.contentView.viewWithTag(100) as! UIActivityIndicatorView
      activityIndicator.startAnimating()
      return cell
    }

    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell",
                                                           for: indexPath) as! HistoryTableViewCell

    let transaction = transactions[(indexPath as NSIndexPath).row] as! CYBSMposTransaction

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
    cell.amountLabel.text = transaction.amount != nil ? NSString(format:"%@%.2f", getCurrencySymbol(code: transaction.currency ?? "USD") ,transaction.amount!.doubleValue) as String : ""

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

    return cell
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if (!self.spinner.isAnimating) && ((indexPath as NSIndexPath).row == (self.transactions.count - 1)) {
      if let result = self.result {
        Utils.createAccessToken { (accessToken, error) in
          if let accessToken = accessToken {
            let manager = Utils.getManager()
            manager.nextTransactionSearchResult(result, accessToken: accessToken, delegate: self)
          } else {
            self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
          }
        }
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTransactionDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let destinationController = segue.destination as! TransactionDetailTableViewController
        destinationController.transaction = transactions[(indexPath as NSIndexPath).row] as? CYBSMposTransaction
      }
    }
  }
    
    func performTransactionSearchDidFinish(_ result: CYBSMposTransactionSearchResult?, error: Error?) {
        self.refreshControl?.endRefreshing()
        self.spinner.stopAnimating()
        if let error = error {
            self.showAlert("Error", message: error.localizedDescription)
        } else if let result = result {
            self.result = result
            if let t = result.transactions {
                if self.didRefresh {
                    transactions.removeAllObjects()
                    didRefresh = false
                }
                transactions.addObjects(from: t)
                tableView.reloadData()
            }
        }
    }

  func showAlert(_ title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true) {
    }
  }

    @objc func refresh() {
    self.didRefresh = true
    getHistory()
  }

  func getHistory() {
    Utils.createAccessToken { (accessToken, error) in
      if let accessToken = accessToken {
        let manager = Utils.getManager()
        manager.performTransactionSearch(self.query, accessToken: accessToken, delegate: self)
      } else {
        self.spinner.stopAnimating()
        self.showAlert("Error", message: (error?.userInfo["message"] as? String) ?? "Failed to get the access token")
      }
    }
  }

}
