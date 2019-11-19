//
//  DeviceManagementViewController.swift
//  CYBSMposKitDemo
//
//  Created by Suman, Kshitiz on 12/14/18.
//  Copyright © 2018 CyberSource. All rights reserved.
//

import UIKit

class DeviceManagementViewController: UITableViewController,CYBSMposManagerDelegate,UITextFieldDelegate {

    @IBOutlet weak var merchantIdTextField: UITextField!
    @IBOutlet weak var deviceIdTextField: UITextField!
    @IBOutlet weak var clientIdTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var clientSecretTextField: UITextField!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    
    var requiredFields:Array<Any>?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.hidesWhenStopped = true
        
        if Settings.sharedInstance.generatingAccessTokenMethod == 0 {
            self.requiredFields = [self.merchantIdTextField , self.clientIdTextField, self.clientSecretTextField]
        } else {
            self.requiredFields = [self.merchantIdTextField , self.clientIdTextField, self.usernameTextField, self.passwordTextField]
        }
        
        self.merchantIdTextField.delegate = self
        self.deviceIdTextField.delegate = self
        self.clientIdTextField.delegate = self
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.clientSecretTextField.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        if Settings.sharedInstance.generatingAccessTokenMethod == 0 {
            return 5
        } else if Settings.sharedInstance.generatingAccessTokenMethod == 1 {
            return 4
        } else {
            return 5
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 60.0
        if Settings.sharedInstance.generatingAccessTokenMethod == 0 {
            if (indexPath.row == 3 || indexPath.row == 4) {
                height = 0.0
            } else {
                height = 60.0
            }
        } else if Settings.sharedInstance.generatingAccessTokenMethod == 1 {
            if (indexPath.row == 5) {
                height = 0.0
            } else {
                height = 60.0
            }
        } else {
            height = 60.0
        }
        
        return height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let settingsDetails = Settings.sharedInstance;
        self.registerButton.isEnabled = true
        self.registerButton.alpha = 1
        self.merchantIdTextField.text = settingsDetails.merchantID
        self.deviceIdTextField.text = settingsDetails.deviceID
        self.clientIdTextField.text = settingsDetails.clientID
        self.usernameTextField.text = settingsDetails.username
        self.passwordTextField.text = settingsDetails.password
        self.clientSecretTextField.text = settingsDetails.clientSecret
        
        self.checkRequiredFields()
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerDeviceClicked(_ sender: Any) {
        self.spinner.startAnimating()
        if Settings.sharedInstance.generatingAccessTokenMethod == 0 {
            let manager = Utils.getManager()

            manager.activateDevice(withClientId: clientIdTextField.text!, withMerchantId: merchantIdTextField.text!, withDeviceId: deviceIdTextField.text!, withClientSecret: clientSecretTextField.text!, withDescription: nil, withDevicePlatform: nil, withSDKVersion: nil, withAppVersion: nil, withPhoneNumber: nil, with: self)
        } else {
            let manager = Utils.getManager()

            manager.activateDevice(withClientId: clientIdTextField.text!, withUserName: usernameTextField.text!, withPassword: passwordTextField.text!, withMerchantId: merchantIdTextField.text!, withDeviceId: deviceIdTextField.text!, withDescription: nil, withDevicePlatform: nil, withSDKVersion: nil, withAppVersion: nil, withPhoneNumber: nil, with:self);
        }
    }
    
    func checkRequiredFields() {
        for field in self.requiredFields! {
            let tF = field as! UITextField
            if Settings.sharedInstance.generatingAccessTokenMethod == 0 {
                if tF.tag == 400 || tF.tag == 500 {
                    continue
                }
            } else {
                if tF.tag == 600 {
                    continue
                }
            }
            if (field as! UITextField).text?.count == 0 {
                self.registerButton.isEnabled = false
                self.registerButton.alpha = 0.5
                return
            }
        }
        self.registerButton.isEnabled = true
        self.registerButton.alpha = 1
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        var s = 4
        s = s + 8
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string.count > 0) {
            textField.text = textField.text! + string
        } else if (textField.text?.count as! Int > 0) {
            textField.text = (textField.text! as NSString).substring(to: (textField.text?.count)!-1)
        }
        self.checkRequiredFields()
        return false
    }
    
    func onDeviceRegister(_ responseData: CYBSMposRegisterDeviceResponse?, error: Error?) {
        self.spinner.stopAnimating()
        if let deviceRegisterResponse = responseData {
            switch(deviceRegisterResponse.status){
            case .setupReady:
                self.showAlert("Device Registration", message:"Setup Ready :\(String(describing: deviceRegisterResponse.message ?? "" ))")
                break
            case .pending:
                self.showAlert("Device Registration", message:"Pending :\(String(describing: deviceRegisterResponse.message ?? "" ))")
                break
            case .unknown:
                self.showAlert("Device Registration", message:"Unknown Error :\(String(describing: deviceRegisterResponse.message ?? "" ))")
                break
            case .disabled:
                self.showAlert("Device Registration", message:"Disabled :\(String(describing: deviceRegisterResponse.message ?? "" ))")
                break
            case .failed:
                self.showAlert("Device Registration", message:"Failed :\(String(describing: deviceRegisterResponse.message ?? "" ))")
                break
            @unknown default:
                self.showAlert("Error", message: (deviceRegisterResponse.message) ?? "Error Occurred :: HTTP Code \(String(describing: deviceRegisterResponse.message ?? "" ))")
                break
            }
        }
        else {
            self.showAlert("Device Registration Error", message: "Error Occurred ::  \(String(error?.localizedDescription ?? ""))")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
