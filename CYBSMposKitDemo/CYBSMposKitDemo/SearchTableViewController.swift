//
//  SearchTableViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 7/28/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

  // MARK: - IBOutlet
  @IBOutlet weak var fromDatePicker: UIDatePicker!
  @IBOutlet weak var toDatePicker: UIDatePicker!

  let timeFormatter = DateFormatter()
  let dateFormatter = DateFormatter()
  let fromDateCellIndexPath = IndexPath(row: 0, section:  0)
  let fromDatePickerCellIndexPath = IndexPath(row: 1, section: 0)
  let toDateCellIndexPath = IndexPath(row: 2, section: 0)
  let toDatePickerCellIndexPath = IndexPath(row: 3, section: 0)
  let todayDateCellIndexPath = IndexPath(row: 4, section: 0)
  let yesterdayDateCellIndexPath = IndexPath(row: 5, section: 0)
  let last60DaysDateCellIndexPath = IndexPath(row: 6, section: 0)
  let filterByAccountSuffixCellIndexPath = IndexPath(row: 0, section: 1)
  let filterByAccountPrefixAndSuffixCellIndexPath = IndexPath(row: 1, section: 1)
  let filterByLastNameCellIndexPath = IndexPath(row: 2, section: 1)
  let filterByDeviceIDCellIndexPath = IndexPath(row: 3, section: 1)
  let filterByMerchantReferenceNumberCellIndexPath = IndexPath(row: 4, section: 1)

  var query = CYBSMposTransactionSearchQuery()
  var selectedDatePickerCellIndexPath: IndexPath?
  var lastSelectedDateCellIndexPath: IndexPath?
  var lastSelectedFilterCellIndexPath: IndexPath?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
    timeFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
    dateFormatter.dateFormat = "yyyy-MM-dd"
    lastSelectedDateCellIndexPath = last60DaysDateCellIndexPath
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showSearchResult" {
      let destinationController = segue.destination as! HistoryTableViewController
      destinationController.query = self.query
    }
  }

  // MARK: - IBAction

  @IBAction func fromDatePickerValueChanged(_ fromDatePicker: UIDatePicker) {
    setDetailTextLabelText(fromDateCellIndexPath, text: timeFormatter.string(from: fromDatePicker.date))
    query.dateFrom = fromDatePicker.date.timeIntervalSince1970
  }

  @IBAction func toDatePickerValueChanged(_ toDatePicker: UIDatePicker) {
    setDetailTextLabelText(toDateCellIndexPath, text: timeFormatter.string(from: toDatePicker.date))
    query.dateTo = toDatePicker.date.timeIntervalSince1970
  }

  @IBAction func search(_ sender: AnyObject) {
    performSegue(withIdentifier: "showSearchResult", sender: self)
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath {
    case fromDateCellIndexPath:
      fromDateCellSelected()
    case toDateCellIndexPath:
      toDateCellSelected()
    case todayDateCellIndexPath:
      todayDateCellSelected()
    case yesterdayDateCellIndexPath:
      yesterdayDateCellSelected()
    case last60DaysDateCellIndexPath:
      last60DaysDateCellSelected()
    case filterByAccountSuffixCellIndexPath:
      filterByAccountSuffixCellSelected()
    case filterByAccountPrefixAndSuffixCellIndexPath:
      filterByAccountPrefixAndSuffixCellSelected()
    case filterByLastNameCellIndexPath:
      filterByLastNameCellSelected()
    case filterByDeviceIDCellIndexPath:
      filterByDeviceIDCellSelected()
    case filterByMerchantReferenceNumberCellIndexPath:
      filterByMerchantReferenceNumberCellSelected()
    default:
      break
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if (indexPath == fromDatePickerCellIndexPath || indexPath == toDatePickerCellIndexPath) && indexPath != selectedDatePickerCellIndexPath {
      return 0
    }
    return super.tableView(tableView, heightForRowAt: indexPath)
  }

  // MARK: -

  func getDetailTextLabelText(_ indexPath: IndexPath) -> String {
    return tableView.cellForRow(at: indexPath)!.detailTextLabel!.text ?? ""
  }

  func setDetailTextLabelText(_ indexPath: IndexPath, text: String) {
    tableView.cellForRow(at: indexPath)?.detailTextLabel!.text = text
    tableView.reloadRows(at: [indexPath], with: .none)
  }

  func fromDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRow(at: lastSelectedDateCellIndexPath!)!.accessoryType = .none
      query.dateFrom = 0
      query.dateTo = 0
    }
    lastSelectedDateCellIndexPath = fromDateCellIndexPath
    tableView.beginUpdates()
    if selectedDatePickerCellIndexPath == fromDatePickerCellIndexPath {
      selectedDatePickerCellIndexPath = nil
    } else {
      selectedDatePickerCellIndexPath = fromDatePickerCellIndexPath
      if getDetailTextLabelText(fromDateCellIndexPath).isEmpty {
        fromDatePicker.date = Date()
      }
      setDetailTextLabelText(fromDateCellIndexPath, text: timeFormatter.string(from: fromDatePicker.date))
      query.dateFrom = fromDatePicker.date.timeIntervalSince1970
    }
    tableView.endUpdates()
  }

  func toDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRow(at: lastSelectedDateCellIndexPath!)!.accessoryType = .none
      query.dateFrom = 0
      query.dateTo = 0
    }
    lastSelectedDateCellIndexPath = toDateCellIndexPath
    tableView.beginUpdates()
    if selectedDatePickerCellIndexPath == toDatePickerCellIndexPath {
      selectedDatePickerCellIndexPath = nil
    } else {
      selectedDatePickerCellIndexPath = toDatePickerCellIndexPath
      if getDetailTextLabelText(toDateCellIndexPath).isEmpty {
        toDatePicker.date = Date()
      }
      setDetailTextLabelText(toDateCellIndexPath, text: timeFormatter.string(from: toDatePicker.date))
      query.dateTo = toDatePicker.date.timeIntervalSince1970
    }
    tableView.endUpdates()
  }

  func todayDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRow(at: lastSelectedDateCellIndexPath!)!.accessoryType = .none
    }
    lastSelectedDateCellIndexPath = todayDateCellIndexPath
    tableView.beginUpdates()
    selectedDatePickerCellIndexPath = nil
    tableView.reloadRows(at: [todayDateCellIndexPath], with: .none)
    tableView.endUpdates()
    tableView.cellForRow(at: todayDateCellIndexPath)!.accessoryType = .checkmark
    query.dateFrom = dateFormatter.date(from: dateFormatter.string(from: Date()))!.timeIntervalSince1970
    query.dateTo = query.dateFrom + 86400
    setDetailTextLabelText(fromDateCellIndexPath, text: "")
    setDetailTextLabelText(toDateCellIndexPath, text: "")
  }

  func yesterdayDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRow(at: lastSelectedDateCellIndexPath!)!.accessoryType = .none
    }
    lastSelectedDateCellIndexPath = yesterdayDateCellIndexPath
    tableView.beginUpdates()
    selectedDatePickerCellIndexPath = nil
    tableView.reloadRows(at: [yesterdayDateCellIndexPath], with: .none)
    tableView.endUpdates()
    tableView.cellForRow(at: yesterdayDateCellIndexPath)!.accessoryType = .checkmark
    query.dateTo = dateFormatter.date(from: dateFormatter.string(from: Date()))!.timeIntervalSince1970
    query.dateFrom = query.dateTo - 86400
    setDetailTextLabelText(fromDateCellIndexPath, text: "")
    setDetailTextLabelText(toDateCellIndexPath, text: "")
  }

  func last60DaysDateCellSelected() {
    if !(lastSelectedDateCellIndexPath == fromDateCellIndexPath || lastSelectedDateCellIndexPath == toDateCellIndexPath) {
      tableView.cellForRow(at: lastSelectedDateCellIndexPath!)!.accessoryType = .none
    }
    lastSelectedDateCellIndexPath = last60DaysDateCellIndexPath
    tableView.beginUpdates()
    selectedDatePickerCellIndexPath = nil
    tableView.reloadRows(at: [last60DaysDateCellIndexPath], with: .none)
    tableView.endUpdates()
    tableView.cellForRow(at: last60DaysDateCellIndexPath)!.accessoryType = .checkmark
    query.dateTo = 0
    query.dateFrom = 0
    setDetailTextLabelText(fromDateCellIndexPath, text: "")
    setDetailTextLabelText(toDateCellIndexPath, text: "")
  }

  func filterByAccountSuffixCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .alert)
    alertController.addTextField(configurationHandler: { (textField) in
      textField.placeholder = "Account Suffix"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByAccountSuffixCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let accountSuffix = alertController.textFields![0].text!
      if accountSuffix.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByAccountSuffixCellIndexPath, text: "")
        self.query.accountSuffix = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByAccountSuffixCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.accountSuffix.rawValue
        self.setDetailTextLabelText(self.filterByAccountSuffixCellIndexPath, text: accountSuffix)
        self.query.accountSuffix = accountSuffix
      }
    }
    alertController.addAction(doneAction)
    DispatchQueue.main.async(execute: {
      self.present(alertController, animated: true) {
      }
    })
  }

  func filterByAccountPrefixAndSuffixCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .alert)
    alertController.addTextField(configurationHandler: { (textField) in
      textField.placeholder = "Account Prefix"
    })
    alertController.addTextField(configurationHandler: { (textField) in
      textField.placeholder = "Account Suffix"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByAccountPrefixAndSuffixCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let accountPrefix = alertController.textFields![0].text!
      let accountSuffix = alertController.textFields![1].text!

      if accountPrefix.isEmpty || accountSuffix.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByAccountPrefixAndSuffixCellIndexPath, text: "")
        self.query.accountPrefix = nil
        self.query.accountSuffix = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByAccountPrefixAndSuffixCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.accountPrefix.rawValue | CYBSMposTransactionSearchQueryFilter.accountSuffix.rawValue
        self.setDetailTextLabelText(self.filterByAccountPrefixAndSuffixCellIndexPath, text: "\(accountPrefix) \(accountSuffix)")
        self.query.accountPrefix = accountPrefix
        self.query.accountSuffix = accountSuffix
      }
    }
    alertController.addAction(doneAction)
    DispatchQueue.main.async(execute: {
      self.present(alertController, animated: true) {
      }
    })
  }

  func filterByLastNameCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .alert)
    alertController.addTextField(configurationHandler: { (textField) in
      textField.placeholder = "Last Name"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByLastNameCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let lastName = alertController.textFields![0].text!
      if lastName.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByLastNameCellIndexPath, text: "")
        self.query.lastName = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByLastNameCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.lastName.rawValue
        self.setDetailTextLabelText(self.filterByLastNameCellIndexPath, text: lastName)
        self.query.lastName = lastName
      }
    }
    alertController.addAction(doneAction)
    DispatchQueue.main.async(execute: {
      self.present(alertController, animated: true) {
      }
    })
  }

  func filterByDeviceIDCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .alert)
    alertController.addTextField(configurationHandler: { (textField) in
      textField.placeholder = "Device ID"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByDeviceIDCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let deviceID = alertController.textFields![0].text!
      if deviceID.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByDeviceIDCellIndexPath, text: "")
        self.query.deviceId = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByDeviceIDCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.deviceId.rawValue
        self.setDetailTextLabelText(self.filterByDeviceIDCellIndexPath, text: deviceID)
        self.query.deviceId = deviceID
      }
    }
    alertController.addAction(doneAction)
    DispatchQueue.main.async(execute: {
      self.present(alertController, animated: true) {
      }
    })
  }

  func filterByMerchantReferenceNumberCellSelected() {
    let alertController = UIAlertController(title: "FILTER BY", message: nil, preferredStyle: .alert)
    alertController.addTextField(configurationHandler: { (textField) in
      textField.placeholder = "Merchant Reference Number"
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
    }
    alertController.addAction(cancelAction)
    let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
      if let lastSelectedFilterCellIndexPath = self.lastSelectedFilterCellIndexPath {
        if lastSelectedFilterCellIndexPath != self.filterByMerchantReferenceNumberCellIndexPath {
          self.setDetailTextLabelText(lastSelectedFilterCellIndexPath, text: "")
        }
      }
      let merchantReferenceNumber = alertController.textFields![0].text!
      if merchantReferenceNumber.isEmpty {
        self.lastSelectedFilterCellIndexPath = nil
        self.query.filters = 0
        self.setDetailTextLabelText(self.filterByMerchantReferenceNumberCellIndexPath, text: "")
        self.query.merchantReferenceCode = nil
      } else {
        self.lastSelectedFilterCellIndexPath = self.filterByMerchantReferenceNumberCellIndexPath
        self.query.filters = CYBSMposTransactionSearchQueryFilter.merchantReferenceCode.rawValue
        self.setDetailTextLabelText(self.filterByMerchantReferenceNumberCellIndexPath, text: merchantReferenceNumber)
        self.query.merchantReferenceCode = merchantReferenceNumber
      }
    }
    alertController.addAction(doneAction)
    DispatchQueue.main.async(execute: {
      self.present(alertController, animated: true) {
      }
    })
  }

}
