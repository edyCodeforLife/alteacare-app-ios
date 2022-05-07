//
//  DocumentViewerVC.swift
//  Altea Care
//
//  Created by Hedy on 19/03/21.
//

import UIKit
import WebKit

class DocumentViewerVC: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webViewFrame: UIView!
    @IBOutlet weak var progressLabel: ACLabel!
    @IBOutlet weak var notificationContainer: UIView!
    @IBOutlet weak var notifContainerHConstraint: NSLayoutConstraint!
    
    var documentTitle: String?
    var webView: WKWebView!
    var resourceType: WebviewResourceType?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.notifContainerHConstraint.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notificationContainer.isHidden = true
        self.setupNavigation()
        self.loadWebview()
    }
    
    private func setupNavigation() {
        self.setTextNavigation(title: documentTitle ?? "", navigator: .close)
        
        let saveBtn = UIBarButtonItem(title: "Simpan", style: .done, target: self, action: #selector(onSaveTapped))
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    @objc private func onSaveTapped() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        foregroundDownload()
    }
    
    
    @IBAction func closeButton(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.notificationContainer.animHide()
    }
    
    private func loadWebview() {
        if let resource = resourceType {
            webView.load(resource)
        } else {
            fatalError("please set resourceType variable!")
        }
    }
    
    private func setupUI() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: self.webViewFrame.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        self.webViewFrame.addSubview(webView)
        self.webView.addSubview(notificationContainer)
    }
    
    private func foregroundDownload() {
        guard let label = resourceType?.label,
              let url = URL(string: label)
        else {
            self.showNotification(text: "File tidak ditemukan")
            return
        }
        
        DownloadManager.loadFileAsync(url: url) { filepath, error in
            self.showNotification(text: error != nil ? error?.localizedDescription : "File berhasil disimpan")
        }
    }
    
    private func showNotification(text: String?) {
        DispatchQueue.main.async {
            self.progressLabel.text = text
            self.progressLabel.textColor = .white
            self.notificationContainer.backgroundColor = .alteaBlueMain
            self.notifContainerHConstraint.constant = 50
            self.notificationContainer.animShow()
        }
    }
}

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}
