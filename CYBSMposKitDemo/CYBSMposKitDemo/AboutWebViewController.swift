//
//  AboutWebViewController.swift
//  CYBSMposKitDemo
//
//  Created by CyberSource on 2/28/19.
//  Copyright © 2019 CyberSource. All rights reserved.
//

import UIKit
import WebKit

class AboutWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    enum AboutSection : Int {
        case PrivacyPolicy = 0
        case HelpFeedback
    }
    
    var aboutSection: AboutSection = .PrivacyPolicy

    var webView:WKWebView = WKWebView()
    @IBOutlet weak var activity: UIActivityIndicatorView!

    func getURL() -> URL? {
        var urlString = ""
        switch aboutSection {
        case .PrivacyPolicy:
            urlString = "https://www.cybersource.com/privacy/"
            break
        case .HelpFeedback:
            urlString = "https://support.cybersource.com/s/"
            break
        }
        return URL(string: urlString)
    }
    
    func setupWebView() {
        webView.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
        webView.scrollView.bounces = true
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.backgroundColor = .white
        webView.scrollView.isOpaque = true
        webView.scrollView.showsHorizontalScrollIndicator = true
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if let url = self.getURL() {
            activity.startAnimating()
            webView.load(URLRequest(url: url))
        }
        self.view.addSubview(webView)
        
        activity.center = view.center
        self.view.addSubview(activity)
        activity.hidesWhenStopped = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activity.stopAnimating()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
