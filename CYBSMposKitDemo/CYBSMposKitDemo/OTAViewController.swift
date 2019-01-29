//
//  OTAViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 04/09/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import Foundation

class OTAViewController: UIViewController, CYBSMposManagerDelegate {
    
    @IBOutlet weak var environmentSwitch: UISwitch!
    var isTestReader: Bool = false

    @IBOutlet var spinner: UIActivityIndicatorView!

    @IBOutlet weak var otaUpdateProgressView: UIView!
    @IBOutlet weak var otaUpdateProgressInternalView: UIView!
    @IBOutlet weak var otaUpdateProgressTypeLbl: UILabel!
    @IBOutlet weak var otaUpdateProgressPercentLbl: UILabel!
    @IBOutlet weak var otaUpdateProgressPercentIndicator: UIProgressView!

    // MARK: - UIViewController
    override func viewDidLoad(){
        super.viewDidLoad()
        
        spinner.center = view.center;
        view.addSubview(spinner)
        spinner.hidesWhenStopped = true
        
        self.isTestReader = self.environmentSwitch.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CYBSMposManager.resetCYBSMposManager()
    }
    
    @IBAction func checkForUpdates(_ sender: AnyObject) {
        DispatchQueue.main.async{
            self.startActivityIndicator()
        }

        let sharedInstance = CYBSMposManager.sharedInstance();
        
        sharedInstance.check(forOTAUpdateIsTestReader: !self.isTestReader) { (iFirmwareUpdateRequired, iConfigurationUpdateRequired, iErrorCode:CYBSMposDeviceErrorCode, iErrorString, iStatusCode:CYBSMposOTAResultCode, iStatusMessage) in
            DispatchQueue.main.async{
                self.stopActivityIndicator()
            }
            if (iErrorCode == CYBSMposDeviceErrorCode.noError) {
                if (iStatusCode == CYBSMposOTAResultCode.success) {
                    if (iFirmwareUpdateRequired || iConfigurationUpdateRequired) {
                        print("update required")
                        self.showAlert("Check for update", message: "Update required")
                    } else {
                        self.showAlert("Check for update", message: "Your reader is upto date")
                    }
                } else {
                    self.showAlert("Check for update error", message: iStatusMessage!)
                }
            } else {
                self.showAlert("Check for update error", message: iErrorString!)
            }
        }
    }
    
    @IBAction func updateConfig(_ sender: AnyObject) {
        DispatchQueue.main.async{
            self.startActivityIndicator()
            self.showUpdateProgressView()
        }
        
        let sharedInstance = CYBSMposManager.sharedInstance()
        sharedInstance.startConfigurationUpdateIsTestReader(!self.isTestReader, withProgress: { (iPercentage:Float, iUpdateType:CYBSMposOTAOperation) in
            print("Progress: %f", iPercentage)
            DispatchQueue.main.async{
                self.updateProgress(iPercentage: iPercentage, iUpdateType: iUpdateType)
            }
        }, andOTACompletionBlock: { (iUpdateSuccessful:Bool, iErrorCode:CYBSMposDeviceErrorCode, iErrorString, iStatusCode:CYBSMposOTAResultCode, iStatusMessage) in
            print("Update completed...")
            DispatchQueue.main.async{
                self.hideUpdateProgressView()
                self.stopActivityIndicator()
            }
            if (iUpdateSuccessful && iErrorCode == CYBSMposDeviceErrorCode.noError) {
                self.showAlert("Reader Updated successfully!", message: "Note: Please make sure reader is restarted properly before using it for next transaction.")
            } else {
                if let errorMsg = iErrorString {
                    self.showAlert("Update failed", message: errorMsg)
                } else {
                    self.showAlert("Update Status", message: iStatusMessage!)
                }
            }
        })
    }

    @IBAction func updateFirmware(_ sender: AnyObject) {
        DispatchQueue.main.async{
            self.startActivityIndicator()
            self.showUpdateProgressView()
        }
        
        let sharedInstance = CYBSMposManager.sharedInstance()
        sharedInstance.startFirmwareUpdateIsTestReader(!self.isTestReader, withProgress: { (iPercentage:Float, iUpdateType:CYBSMposOTAOperation) in
            print("Progress: %f", iPercentage)
            DispatchQueue.main.async{
                self.updateProgress(iPercentage: iPercentage, iUpdateType: iUpdateType)
            }
        }, andOTACompletionBlock: { (iUpdateSuccessful:Bool, iErrorCode:CYBSMposDeviceErrorCode, iErrorString, iStatusCode:CYBSMposOTAResultCode, iStatusMessage) in
            print("Update completed...")
            DispatchQueue.main.async{
                self.hideUpdateProgressView()
                self.stopActivityIndicator()
            }
            if (iUpdateSuccessful && iErrorCode == CYBSMposDeviceErrorCode.noError) {
                self.showAlert("Reader Updated successfully!", message: "Note: Please make sure reader is restarted properly before using it for next transaction.")
            } else {
                if let errorMsg = iErrorString {
                    self.showAlert("Update failed", message: errorMsg)
                } else {
                    self.showAlert("Update Status", message: iStatusMessage!)
                }
            }
        })
    }

    @IBAction func updateAll(_ sender: AnyObject) {
        DispatchQueue.main.async{
            self.startActivityIndicator()
            self.showUpdateProgressView()
        }

        let sharedInstance = CYBSMposManager.sharedInstance();
        sharedInstance.startOTAUpdateIsTestReader(!self.isTestReader, withProgress: { (iPercentage:Float, iUpdateType:CYBSMposOTAOperation) in
            print("Progress: %f", iPercentage)
            DispatchQueue.main.async{
                self.updateProgress(iPercentage: iPercentage, iUpdateType: iUpdateType)
            }
        }, andOTACompletionBlock: { (iUpdateSuccessful:Bool, iErrorCode:CYBSMposDeviceErrorCode, iErrorString, iStatusCode:CYBSMposOTAResultCode, iStatusMessage) in
            print("Update completed...")
            DispatchQueue.main.async{
                self.hideUpdateProgressView()
                self.stopActivityIndicator()
            }
            if (iUpdateSuccessful && iErrorCode == CYBSMposDeviceErrorCode.noError) {
                self.showAlert("Reader Updated successfully!", message: "Note: Please make sure reader is restarted properly before using it for next transaction.")
            }  else {
                if let errorMsg = iErrorString {
                    self.showAlert("Update failed", message: errorMsg)
                } else {
                    self.showAlert("Update Status", message: iStatusMessage!)
                }
            }
        })
    }

    @IBAction func getDeviceInfo(_ sender: AnyObject) {
        DispatchQueue.main.async{
            self.startActivityIndicator()
        }
        let sharedInstance = CYBSMposManager.sharedInstance()
        sharedInstance.getDeviceInfo(self)
    }
    
    @IBAction func environmentSwitchValueChange(_ sender: UISwitch) {
        self.isTestReader = sender.isOn
    }
    
    func setConnectionMode() {
    }
    
    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {
        }
    }
    
    func startActivityIndicator() {
        self.spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopActivityIndicator() {
        self.spinner.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    func updateProgress(iPercentage: Float, iUpdateType: CYBSMposOTAOperation) {
        if iUpdateType == .firmwareUpdate {
            self.otaUpdateProgressTypeLbl.text = "Updating Firmware"
        } else if iUpdateType == .configUpdate {
            self.otaUpdateProgressTypeLbl.text = "Updating Configuration"
        }
        
        //var actualProgress = iPercentage%100
        self.otaUpdateProgressPercentLbl.text = String(format: "%f%@", iPercentage, "%")
        self.otaUpdateProgressPercentIndicator.progress = iPercentage/100.0;
    }
    
    func showUpdateProgressView() {
        self.otaUpdateProgressView.isHidden = false;
        UIView.animate(withDuration: 0.5) {
            self.otaUpdateProgressInternalView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hideUpdateProgressView() {
        self.otaUpdateProgressView.isHidden = true;
        UIView.animate(withDuration: 0.5) {
            self.otaUpdateProgressInternalView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func onReturnDeviceInfo(_ deviceInfo: [AnyHashable : Any]?) {
        DispatchQueue.main.async{
            self.stopActivityIndicator()
        }

        let responseString = deviceInfo?.reduce("") { $0.isEmpty ? "\($1.key):\($1.value)" : "\($0)\n-----------------------------\n\($1.key):\($1.value)" }

        let actionSheetController: UIAlertController = UIAlertController(title: "", message: responseString, preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(yesAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func onReturnDeviceError(_ iErrorCode: CYBSMposDeviceErrorCode, errorMessage iErrorMessage: String?) {
        DispatchQueue.main.async{
            self.stopActivityIndicator()
        }
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: iErrorMessage, preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(yesAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
}
