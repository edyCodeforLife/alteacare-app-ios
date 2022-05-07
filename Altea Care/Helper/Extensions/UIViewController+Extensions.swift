//
//  UIViewController+Extensions.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setupHideKeyboardWhenTappedAround() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(UIViewController.dismissThisKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissThisKeyboard() {
        view.endEditing(true)
    }
    
    ///setup view button when active
    ///Corner radius 8
    ///Background color primary
    func setupActiveButton(button : UIButton){
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = UIColor.alteaMainColor.cgColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.font(fontType: .bold)
    }
    
    ///setup view button when deactive
    ///Corner radius 8
    ///Background color primary
    func setupDeactiveButton(button : UIButton){
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = UIColor.alteaDark2.cgColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.font(fontType: .bold)
    }
    
    /// button active
    /// corner radius
    /// bordor color primary
    func setupSecondaryButton(button : UIButton){
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.primary.cgColor
        button.setTitleColor(UIColor.primary, for: .normal)
    }
    
    func wrapInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass)
    }
    
    class func controllerFromStoryboard(_ storyboard: Storyboard) -> Self {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: nameOfClass)
    }
}


public func dismissKeyboard() {
    UIApplication
        .shared
        .sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
}

enum Storyboard: String {
    case main = "Main"
    case login = "Login"
}
