//
//  VaccineVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 02/07/21.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate, WebView {
    
    var url: String!
    var goHome: (() -> Void)?
    var isNeedLogin: Bool!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    let accessToken = Preference.getString(forKey: .AccessTokenKey)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isNeedLogin {
            setCredentialCookie()
        }
        self.setupWebView(url: url)
    }
    
    deinit {
        removeObserver()
    }
    
    private func removeObserver() {
        self.webView.removeObserver(self, forKeyPath: "URL")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    func setCredentialCookie() {
        let seconds = 31556926.0
        guard let cookie = HTTPCookie(properties: [
            .domain: ".alteacare.com",
            .path: "/",
            .name: "alt_user_token",
            .value: accessToken ?? "",
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: seconds)
        ]) else { return }
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
    }
    
    func setupWebView(url : String){
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        guard let url = URL(string: url) else {
            return
        }
        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(URLRequest(url: url as URL))
        webView.allowsBackForwardNavigationGestures = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func bindViewModel() {
        
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        setUIDocumentMenuViewControllerSoureViewsIfNeeded(viewControllerToPresent)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func setUIDocumentMenuViewControllerSoureViewsIfNeeded(_ viewControllerToPresent: UIViewController) {
        if #available(iOS 13, *), viewControllerToPresent is UIDocumentMenuViewController && UIDevice.current.userInterfaceIdiom == .phone {
            // Prevent the app from crashing if the WKWebView decides to present a UIDocumentMenuViewController while it self is presented modally.
            viewControllerToPresent.popoverPresentationController?.sourceView = webView
            viewControllerToPresent.popoverPresentationController?.sourceRect = CGRect(x: webView.center.x, y: webView.center.y, width: 1, height: 1)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            let url = "\(self.webView.url ?? URL(fileURLWithPath: ""))"
            print("url :", url)
            if url.contains("vaccine-close") || url.contains("backtomobile"){
                self.goHome?()
            }
        }
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            // When page load finishes. Should work on each page reload.
            if (self.webView.estimatedProgress == 1) {
                
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, let scheme = url.scheme?.lowercased() {
                if scheme != "https" && scheme != "http" {
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url)
                    }
                }
            }
        decisionHandler(.allow)
    }
}
