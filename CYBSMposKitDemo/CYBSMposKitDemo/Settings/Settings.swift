//
//  Settings.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 6/14/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import Foundation

class Settings : NSObject, NSCoding {
    
    static let sharedInstance = Settings()
    static let environments = ["LIVE", "TEST"]
    static let defaultEnvironment = 1
    
    var merchantID: String?
    var deviceID: String?
    var clientID: String?
    var clientSecret: String?
    var username: String?
    var password: String?
    var accessToken: String?
    var generatingAccessTokenMethod: Int = 0
    var terminalID: String?
    var terminalIDAlternate: String?
    var mid: String?
    var readerType: Int = 1
    var decryptionServiceType: Int = 0
    var serviceType: Int = 3
    var commereceIndicator: Int = 0
    var signatureMinAmount: Float = 1.00
    var enableTokenization: Bool = true
    var mddField1: String?
    var mddField2: String?
    var mddField3: String?
    var mddField4: String?
    var mddField5: String?
    var merchantTransactionIdentifier: String?
    var showReceipt: Bool = true
    var partialAuthIndicator: Bool = false
    var simpleOrderAPIVersion: String?
    var topImageURL: String?
    var backgroundColor: String?
    var spinnerColor: String?
    var textLabelColor: String?
    var detailLabelColor: String?
    var textFieldColor: String?
    var placeholderColor: String?
    var signatureColor: String?
    var signatureBackgroundColor: String?
    var tintColor: String?
    var ultraLightFont: String?
    var thinFont: String?
    var lightFont: String?
    var regularFont: String?
    var mediumFont: String?
    var semiboldFont: String?
    var boldFont: String?
    var heavyFont: String?
    var blackFont: String?
    var currency: String? = "USD"

    required convenience init(settings: Dictionary<String, String>) {
        self.init()
        merchantID = settings["merchantID"]
        deviceID = settings["deviceID"]
        clientID = settings["clientID"]
        clientSecret = settings["clientSecret"]
        username = settings["username"]
        password = settings["password"]
        accessToken = settings["accessToken"]
        generatingAccessTokenMethod = Int(settings["generatingAccessTokenMethod"] ?? "0") ?? 0
        terminalID = settings["terminalID"]
        terminalIDAlternate = settings["terminalIDAlternate"]
        mid = settings["mid"]
        readerType = Int(settings["readerType"] ?? "1") ?? 1
        decryptionServiceType = Int(settings["readerType"] ?? "0") ?? 0
        serviceType = Int(settings["serviceType"] ?? "3") ?? 3
        commereceIndicator = Int(settings["commereceIndicator"] ?? "0") ?? 0
        partialAuthIndicator = NSString(string:settings["partialAuthIndicator"] ?? "false").boolValue
        signatureMinAmount = Float(settings["signatureMinAmount"] ?? "1.00") ?? 1.00
        enableTokenization = NSString(string:settings["enableTokenization"] ?? "true").boolValue
        mddField1 = settings["mddField1"]
        mddField2 = settings["mddField2"]
        mddField3 = settings["mddField3"]
        mddField4 = settings["mddField4"]
        mddField5 = settings["mddField5"]
        merchantTransactionIdentifier = settings["merchantTransactionIdentifier"]
        simpleOrderAPIVersion = settings["simpleOrderAPIVersion"]
        topImageURL = settings["topImageURL"]
        backgroundColor = settings["backgroundColor"]
        spinnerColor = settings["spinnerColor"]
        textLabelColor = settings["textLabelColor"]
        detailLabelColor = settings["detailLabelColor"]
        textFieldColor = settings["textFieldColor"]
        placeholderColor = settings["placeholderColor"]
        signatureColor = settings["signatureColor"]
        signatureBackgroundColor = settings["signatureBackgroundColor"]
        tintColor = settings["tintColor"]
        ultraLightFont = settings["ultraLightFont"]
        thinFont = settings["thinFont"]
        lightFont = settings["lightFont"]
        regularFont = settings["regularFont"]
        mediumFont = settings["mediumFont"]
        semiboldFont = settings["semiboldFont"]
        boldFont = settings["boldFont"]
        heavyFont = settings["heavyFont"]
        blackFont = settings["blackFont"]
        currency = settings["currency"]
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        merchantID = aDecoder.decodeObject(forKey: "merchantID") as? String
        deviceID = aDecoder.decodeObject(forKey: "deviceID") as? String
        clientID = aDecoder.decodeObject(forKey: "clientID") as? String
        clientSecret = aDecoder.decodeObject(forKey: "clientSecret") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        password = aDecoder.decodeObject(forKey: "password") as? String
        accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String
        generatingAccessTokenMethod = aDecoder.decodeInteger(forKey: "generatingAccessTokenMethod")
        terminalID = aDecoder.decodeObject(forKey: "terminalID") as? String
        terminalIDAlternate = aDecoder.decodeObject(forKey: "terminalIDAlternate") as? String
        mid = aDecoder.decodeObject(forKey: "mid") as? String
        readerType = aDecoder.decodeInteger(forKey: "readerType")
        decryptionServiceType = aDecoder.decodeInteger(forKey: "decryptionServiceType")
        serviceType = aDecoder.decodeInteger(forKey: "serviceType")
        commereceIndicator = aDecoder.decodeInteger(forKey: "commereceIndicator")
        partialAuthIndicator = aDecoder.decodeBool(forKey: "partialAuthIndicator")
        if let amtStr = aDecoder.decodeObject(forKey: "signatureMinAmount") as? String {
            signatureMinAmount = Float(amtStr)!
        } else {
            signatureMinAmount = 1.0
        }

        enableTokenization = aDecoder.decodeBool(forKey: "enableTokenization")
        mddField1 = aDecoder.decodeObject(forKey: "mddField1") as? String
        mddField2 = aDecoder.decodeObject(forKey: "mddField2") as? String
        mddField3 = aDecoder.decodeObject(forKey: "mddField3") as? String
        mddField4 = aDecoder.decodeObject(forKey: "mddField4") as? String
        mddField5 = aDecoder.decodeObject(forKey: "mddField5") as? String
        merchantTransactionIdentifier = aDecoder.decodeObject(forKey: "merchantTransactionIdentifier") as? String
        simpleOrderAPIVersion = aDecoder.decodeObject(forKey: "simpleOrderAPIVersion") as? String
        topImageURL = aDecoder.decodeObject(forKey: "topImageURL") as? String
        backgroundColor = aDecoder.decodeObject(forKey: "backgroundColor") as? String
        spinnerColor = aDecoder.decodeObject(forKey: "spinnerColor") as? String
        textLabelColor = aDecoder.decodeObject(forKey: "textLabelColor") as? String
        detailLabelColor = aDecoder.decodeObject(forKey: "detailLabelColor") as? String
        textFieldColor = aDecoder.decodeObject(forKey: "textFieldColor") as? String
        placeholderColor = aDecoder.decodeObject(forKey: "placeholderColor") as? String
        signatureColor = aDecoder.decodeObject(forKey: "signatureColor") as? String
        signatureBackgroundColor = aDecoder.decodeObject(forKey: "signatureBackgroundColor") as? String
        tintColor = aDecoder.decodeObject(forKey: "tintColor") as? String
        ultraLightFont = aDecoder.decodeObject(forKey: "ultraLightFont") as? String
        thinFont = aDecoder.decodeObject(forKey: "thinFont") as? String
        lightFont = aDecoder.decodeObject(forKey: "lightFont") as? String
        regularFont = aDecoder.decodeObject(forKey: "regularFont") as? String
        mediumFont = aDecoder.decodeObject(forKey: "mediumFont") as? String
        semiboldFont = aDecoder.decodeObject(forKey: "semiboldFont") as? String
        boldFont = aDecoder.decodeObject(forKey: "boldFont") as? String
        heavyFont = aDecoder.decodeObject(forKey: "heavyFont") as? String
        blackFont = aDecoder.decodeObject(forKey: "blackFont") as? String
        currency = aDecoder.decodeObject(forKey: "currency") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(merchantID, forKey: "merchantID")
        aCoder.encode(deviceID, forKey: "deviceID")
        aCoder.encode(clientID, forKey: "clientID")
        aCoder.encode(clientSecret, forKey: "clientSecret")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(generatingAccessTokenMethod, forKey: "generatingAccessTokenMethod")
        aCoder.encode(terminalID, forKey: "terminalID")
        aCoder.encode(terminalIDAlternate, forKey: "terminalIDAlternate")
        aCoder.encode(mid, forKey: "mid")
        aCoder.encode(readerType, forKey: "readerType")
        aCoder.encode(decryptionServiceType, forKey: "decryptionServiceType")
        aCoder.encode(serviceType, forKey: "serviceType")
        aCoder.encode(commereceIndicator, forKey: "commereceIndicator")
        aCoder.encode(partialAuthIndicator, forKey: "partialAuthIndicator")
        let amt = String(format: "%.2f", signatureMinAmount)
        aCoder.encode(amt, forKey: "signatureMinAmount")
        aCoder.encode(enableTokenization, forKey: "enableTokenization")
        aCoder.encode(mddField1, forKey: "mddField1")
        aCoder.encode(mddField2, forKey: "mddField2")
        aCoder.encode(mddField3, forKey: "mddField3")
        aCoder.encode(mddField4, forKey: "mddField4")
        aCoder.encode(mddField5, forKey: "mddField5")
        aCoder.encode(merchantTransactionIdentifier, forKey: "merchantTransactionIdentifier")
        aCoder.encode(simpleOrderAPIVersion, forKey: "simpleOrderAPIVersion")
        aCoder.encode(topImageURL, forKey: "topImageURL")
        aCoder.encode(backgroundColor, forKey: "backgroundColor")
        aCoder.encode(spinnerColor, forKey: "spinnerColor")
        aCoder.encode(textLabelColor, forKey: "textLabelColor")
        aCoder.encode(detailLabelColor, forKey: "detailLabelColor")
        aCoder.encode(textFieldColor, forKey: "textFieldColor")
        aCoder.encode(placeholderColor, forKey: "placeholderColor")
        aCoder.encode(signatureColor, forKey: "signatureColor")
        aCoder.encode(signatureBackgroundColor, forKey: "signatureBackgroundColor")
        aCoder.encode(tintColor, forKey: "tintColor")
        aCoder.encode(ultraLightFont, forKey: "ultraLightFont")
        aCoder.encode(thinFont, forKey: "thinFont")
        aCoder.encode(lightFont, forKey: "lightFont")
        aCoder.encode(regularFont, forKey: "regularFont")
        aCoder.encode(mediumFont, forKey: "mediumFont")
        aCoder.encode(semiboldFont, forKey: "semiboldFont")
        aCoder.encode(boldFont, forKey: "boldFont")
        aCoder.encode(heavyFont, forKey: "heavyFont")
        aCoder.encode(blackFont, forKey: "blackFont")
        aCoder.encode(currency, forKey: "currency")
    }
    
    func reload() {
        reset()
        let key = Settings.environments[Settings.getEnvironment()].lowercased()
        let data = KeychainStore.getSecureData(forKey: key)
        if (data != nil) {
            if let settings = NSKeyedUnarchiver.unarchiveObject(with: data!) as? Settings {
                merchantID = settings.merchantID
                deviceID = settings.deviceID
                clientID = settings.clientID
                clientSecret = settings.clientSecret
                username = settings.username
                password = settings.password
                accessToken = settings.accessToken
                generatingAccessTokenMethod = settings.generatingAccessTokenMethod
                terminalID = settings.terminalID
                terminalIDAlternate = settings.terminalIDAlternate
                mid = settings.mid
                readerType = settings.readerType
                decryptionServiceType = settings.decryptionServiceType
                serviceType = settings.serviceType
                commereceIndicator = settings.commereceIndicator
                partialAuthIndicator = settings.partialAuthIndicator
                signatureMinAmount = settings.signatureMinAmount
                enableTokenization = settings.enableTokenization
                mddField1 = settings.mddField1
                mddField2 = settings.mddField2
                mddField3 = settings.mddField3
                mddField4 = settings.mddField4
                mddField5 = settings.mddField5
                merchantTransactionIdentifier = settings.merchantTransactionIdentifier
                simpleOrderAPIVersion = settings.simpleOrderAPIVersion
                topImageURL = settings.topImageURL
                backgroundColor = settings.backgroundColor
                spinnerColor = settings.spinnerColor
                textLabelColor = settings.textLabelColor
                detailLabelColor = settings.detailLabelColor
                textFieldColor = settings.textFieldColor
                placeholderColor = settings.placeholderColor
                signatureColor = settings.signatureColor
                signatureBackgroundColor = settings.signatureBackgroundColor
                tintColor = settings.tintColor
                ultraLightFont = settings.ultraLightFont
                thinFont = settings.thinFont
                lightFont = settings.lightFont
                regularFont = settings.regularFont
                mediumFont = settings.mediumFont
                semiboldFont = settings.semiboldFont
                boldFont = settings.boldFont
                heavyFont = settings.heavyFont
                blackFont = settings.blackFont
                currency = settings.currency
            }
        }
    }
    
    func reset() {
        merchantID = nil
        deviceID = nil
        clientID = nil
        clientSecret = nil
        username = nil
        password = nil
        accessToken = nil
        generatingAccessTokenMethod = 0
        terminalID = nil
        terminalIDAlternate = nil
        mid = nil
        readerType = 1
        decryptionServiceType = 0
        serviceType = 3
        commereceIndicator = 0
        partialAuthIndicator = false
        signatureMinAmount = 1.00
        enableTokenization = true
        mddField1 = nil
        mddField2 = nil
        mddField3 = nil
        mddField4 = nil
        mddField5 = nil
        merchantTransactionIdentifier = nil
        simpleOrderAPIVersion = nil
        topImageURL = nil
        backgroundColor = nil
        spinnerColor = nil
        textLabelColor = nil
        detailLabelColor = nil
        textFieldColor = nil
        placeholderColor = nil
        signatureColor = nil
        signatureBackgroundColor = nil
        tintColor = nil
        ultraLightFont = nil
        thinFont = nil
        lightFont = nil
        regularFont = nil
        mediumFont = nil
        semiboldFont = nil
        boldFont = nil
        heavyFont = nil
        blackFont = nil
        currency = "USD"
    }
    
    func save() {
        let key = Settings.environments[Settings.getEnvironment()].lowercased()
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        KeychainStore.storeSecureData(data, forKey: key)
    }
    
    class func getEnvironment() -> Int {
        let prefs = UserDefaults.standard
        if let environment = prefs.object(forKey: "environment") as? Int , environment < environments.count {
            return environment
        }
        return Settings.defaultEnvironment
    }
    
    class func setEnvironment(_ environment: Int) {
        let prefs = UserDefaults.standard
        prefs.setValue(environment, forKey: "environment")
    }
    
}
