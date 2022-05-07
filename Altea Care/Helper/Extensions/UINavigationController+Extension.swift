//
//  UINavigationController+Extension.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import UIKit

extension UIViewController {

    func setTextNavigation(title: String, navigator: AMViewNavigatorType = .none, navigatorCallback: Selector? = nil) {
        self.setupTitleForNavigation(title: title)
        self.setupNavigatorForNavigation(type: navigator, navigatorCallback: navigatorCallback)
    }
    
    func setImageNavigation(navigator: AMViewNavigatorType = .none, navigatorCallback: Selector? = nil) {
        self.setupImageForNavigation()
        self.setupNavigatorForNavigation(type: navigator, navigatorCallback: navigatorCallback)
    }
    
    private func setupTitleForNavigation(title: String) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = title
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.alteaBlueMain,
                     NSAttributedString.Key.font: UIFont.font(size: 18, fontType: .bold)]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupImageForNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let logo = UIImage(named: "")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    private func setupNavigatorForNavigation(type: AMViewNavigatorType, navigatorCallback: Selector? = nil) {
        if let callback = navigatorCallback {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: type.icon, style: .plain, target: self, action: callback)
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: type.icon, style: .plain, target: self, action: type.callback)
        }
    }
    
    enum AMViewNavigatorType {
        case none
        case back
        case close
        
        var icon: UIImage {
            switch self {
            case .none:
                return UIImage()
            case .back:
                return UIImage(named: "ic_back")!
            case .close:
                return UIImage(named: "ic_close")!
            }
        }
        
        var callback: Selector {
            switch self {
            case .none:
                return #selector(onBlankTapped)
            case .back:
                return #selector(onBackTapped)
            case .close:
                return #selector(onCloseTapped)
            }
        }
        
    }
    
    
    @objc private func onBlankTapped() { }
    
    @objc private func onBackTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func onCloseTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: UIFont.FontLibrary.normal.rawValue, size: 14)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.3, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
