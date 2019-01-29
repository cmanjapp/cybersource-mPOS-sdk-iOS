//
//  Utils.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 7/26/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

import UIKit

class Cache: NSObject {
  var expiration: TimeInterval = 0
  var value: AnyObject?
}

class Utils: NSObject, URLSessionDelegate {

  static let defaultSettings: Dictionary<String, Dictionary<String, String>> = [:]

static let cache = NSCache<AnyObject, AnyObject>()

  func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                  completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    completionHandler(.performDefaultHandling, URLCredential(trust: challenge.protectionSpace.serverTrust!))
  }

  class func createAccessToken(_ completionHandler:@escaping (_ accessToken: String?, _ error: NSError?) -> Void) {
    let accessToken = Settings.sharedInstance.accessToken ?? ""

    if Settings.sharedInstance.generatingAccessTokenMethod == 2 {
      completionHandler(accessToken, nil)
      return
    }

    if let accessTokenCache = cache.object(forKey: "accessToken" as AnyObject) as? Cache , accessTokenCache.expiration >= Date().timeIntervalSince1970 {
      if let accessToken = accessTokenCache.value as? String {
        completionHandler(accessToken, nil)
        return
      }
    }

    let headers = [
      "cache-control": "no-cache",
      "content-type": "application/x-www-form-urlencoded"
    ]

    let createTokenRequest = createGeneratingAccessTokenRequest()

    let request = NSMutableURLRequest(url: getGeneratingAccessTokenURL(),
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)

    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = createTokenRequest.data(using: String.Encoding.utf8)

    let configuration = URLSessionConfiguration.default
    let session = Foundation.URLSession(configuration: configuration, delegate: Utils(), delegateQueue: nil)
     let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        DispatchQueue.main.async {
            completionHandler(nil, error as NSError?)
        }
        return
      }
      if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            if let accessToken = json["access_token"] as? String {
              let accessTokenCache = Cache()
              accessTokenCache.expiration = Date().timeIntervalSince1970 + 240
                accessTokenCache.value = accessToken as AnyObject
                cache.setObject(accessTokenCache, forKey: "accessToken" as AnyObject)
              DispatchQueue.main.async {
                completionHandler(accessToken, nil)
              }
            } else {
              DispatchQueue.main.async {
                completionHandler(nil, NSError(domain: "CYBSMposKitDemoError", code: 101,
                  userInfo: ["message": "Failed to get the access token"]))
              }
            }
          } catch {
            DispatchQueue.main.async {
                completionHandler(nil, NSError(domain: "CYBSMposKitDemoError", code: 102,
                                               userInfo: ["message": "Failed to parse the JSON response"]))
            }
          }
        } else {
          var message: String
          do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
            print(json)
            if let errorDescription = json["error_description"] as? String {
                message = "Get OAuth access token: " + errorDescription
            } else {
              message = "http status: \(httpResponse.statusCode) response: " +
                (NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String)
            }
          } catch {
            message = "http status: \(httpResponse.statusCode)"
          }
          DispatchQueue.main.async {
            completionHandler(nil, NSError(domain: "CYBSMposKitDemoError", code: 103,
              userInfo: ["message": message]))
          }
        }
      }
    })

    dataTask.resume()
  }

class func getManager() -> CYBSMposManager {
    let settings = getSettings()
    settings.terminalID = Settings.sharedInstance.terminalID ?? ""
    settings.terminalIDAlternate = Settings.sharedInstance.terminalIDAlternate ?? ""
    settings.mid = Settings.sharedInstance.mid ?? ""
    settings.simpleOrderAPIVersion = Settings.sharedInstance.simpleOrderAPIVersion ?? ""
    let manager = CYBSMposManager.sharedInstance()
    manager.settings = settings
    let uiSettings = CYBSMposUISettings()
    if let topImageURL = Settings.sharedInstance.topImageURL , !topImageURL.isEmpty {
      if let imageURL = URL(string: topImageURL) {
        if let imageData = try? Data(contentsOf: imageURL) {
          uiSettings.topImage = UIImage(data: imageData)
        }
      }
    }
    uiSettings.backgroundColor = getUIColor(Settings.sharedInstance.backgroundColor)
    uiSettings.tintColor = getUIColor(Settings.sharedInstance.tintColor) ?? UIApplication.shared.delegate?.window??.rootViewController?.view.tintColor;
    uiSettings.spinnerColor = getUIColor(Settings.sharedInstance.spinnerColor)
    uiSettings.textLabelColor = getUIColor(Settings.sharedInstance.textLabelColor)
    uiSettings.detailTextLabelColor = getUIColor(Settings.sharedInstance.detailLabelColor)
    uiSettings.textFieldColor = getUIColor(Settings.sharedInstance.textFieldColor)
    uiSettings.textFieldPlaceholderColor = getUIColor(Settings.sharedInstance.placeholderColor)
    uiSettings.signatureColor = getUIColor(Settings.sharedInstance.signatureColor)
    uiSettings.signatureBackgroundColor = getUIColor(Settings.sharedInstance.signatureBackgroundColor)
    uiSettings.ultraLightFontName = Settings.sharedInstance.ultraLightFont
    uiSettings.thinFontName = Settings.sharedInstance.thinFont
    uiSettings.lightFontName = Settings.sharedInstance.lightFont
    uiSettings.regularFontName = Settings.sharedInstance.regularFont
    uiSettings.mediumFontName = Settings.sharedInstance.mediumFont
    uiSettings.semiboldFontName = Settings.sharedInstance.semiboldFont
    uiSettings.boldFontName = Settings.sharedInstance.boldFont
    uiSettings.heavyFontName = Settings.sharedInstance.heavyFont
    uiSettings.blackFontName = Settings.sharedInstance.blackFont
    manager.uiSettings = uiSettings
    manager.updateSettings()
    
    let merchantData = getMerchantDescriptorSettings()
    manager.updateMerchantDescriptorSettings(merchantData)
    
    return manager;
  }

  class func getUIColor(_ hex: String?) -> UIColor? {
    if let hex = hex , !hex.isEmpty {
      let scanner = Scanner(string: hex)
      var color: UInt32 = 0
      scanner.scanHexInt32(&color)
      let mask = 0x000000FF
      let r = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
      let g = CGFloat(Float(Int(color >> 8) & mask) / 255.0)
      let b = CGFloat(Float(Int(color) & mask) / 255.0)
      return UIColor(red: r, green: g, blue: b, alpha: CGFloat(1.0))
    }
    return nil
  }

  fileprivate class func createGeneratingAccessTokenRequest() -> String {
    var urlComponents = URLComponents()

    let platform = URLQueryItem(name: "platform", value: "1")
    let deviceID = URLQueryItem(name: "device_id", value: Settings.sharedInstance.deviceID ?? "")
    let merchantID = URLQueryItem(name: "merchant_id", value: Settings.sharedInstance.merchantID ?? "")
    let clientID = URLQueryItem(name: "client_id", value: Settings.sharedInstance.clientID ?? "")

    if Settings.sharedInstance.generatingAccessTokenMethod == 0 {
      let grantType = URLQueryItem(name: "grant_type", value: "client_credentials")
      let clientSecret = URLQueryItem(name: "client_secret", value: Settings.sharedInstance.clientSecret ?? "")
      urlComponents.queryItems = [platform, grantType, deviceID, merchantID, clientID, clientSecret];
    } else {
      let grantType = URLQueryItem(name: "grant_type", value: "password")
      let username = URLQueryItem(name: "username", value: Settings.sharedInstance.username ?? "")
      let password = URLQueryItem(name: "password", value: Settings.sharedInstance.password ?? "")
      urlComponents.queryItems = [platform, grantType, deviceID, merchantID, clientID, username, password];
    }

    return urlComponents.url!.query!
  }

  fileprivate class func getSettings() -> CYBSMposSettings {
    let deviceID = Settings.sharedInstance.deviceID ?? ""
    switch Settings.getEnvironment() {
    case 0:
      return CYBSMposSettings(environment: .live, deviceID: deviceID)
    case 1:
      return CYBSMposSettings(environment: .test, deviceID: deviceID)
    default:
      return CYBSMposSettings(environment: .test, deviceID: deviceID)
    }
  }

    fileprivate class func getMerchantDescriptorSettings() -> CYBSMerchantDescriptor {
        let mdSettings = CYBSMerchantDescriptor()
        mdSettings.merchantDescriptorBusinessName = "CyberSource mPOS Store"
        mdSettings.merchantDescriptorStreet = "901 Metro center Blvd"
        mdSettings.merchantDescriptorCity = "Foster City"
        mdSettings.merchantDescriptorState = "CA"
        mdSettings.merchantDescriptorCountry = "USA"
        mdSettings.merchantDescriptorPostalCode = "94404"
        mdSettings.merchantDescriptorPhoneNumber = "650-302-7012"
        mdSettings.merchantDescriptorEmail = "usriniva@visa.com"
        
        return mdSettings
    }

  fileprivate class func getGeneratingAccessTokenURL() -> URL {
    switch Settings.getEnvironment() {
    case 0:
      return URL(string: "https://auth.ic3.com/apiauth/v1/oauth/token")!
    case 1:
      return URL(string: "https://authtest.ic3.com/apiauth/v1/oauth/token")!
    default:
      return URL(string: "https://authtest.ic3.com/apiauth/v1/oauth/token")!
    }
  }

  class func initSettings() {
    for environment in Settings.environments {
      if (KeychainStore.getSecureData(forKey: environment.lowercased()) == nil) {
        if let defaultSettings = defaultSettings[environment.lowercased()] {
          save(Settings(settings: defaultSettings), environment: environment)
        } else {
          save(Settings(), environment: environment)
        }
      }
    }
    let prefs = UserDefaults.standard
    if (prefs.object(forKey: "environment") as? Int) == nil {
      prefs.setValue(Settings.defaultEnvironment, forKey: "environment")
    }
  }

  class func resetSettings() {
    for environment in Settings.environments {
      KeychainStore.deleteKeychainValue(environment.lowercased())
    }
    let prefs = UserDefaults.standard
    prefs.set(nil, forKey: "environment")
    initSettings()
  }

  fileprivate class func save(_ settings: Settings, environment: String) {
    let data = NSKeyedArchiver.archivedData(withRootObject: settings)
    KeychainStore.storeSecureData(data, forKey: environment.lowercased())
  }
    

}

func getCurrencySymbol(code:String) -> String {
    if code.isEmpty {
        return ""
    }
    var locale = Locale.current
    let numberFormatter: NumberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    if (locale.currencyCode != code) {
        let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: code])
        locale = NSLocale(localeIdentifier: identifier) as Locale
    }
    numberFormatter.locale = locale
    let str = numberFormatter.currencySymbol!
    return str
}
