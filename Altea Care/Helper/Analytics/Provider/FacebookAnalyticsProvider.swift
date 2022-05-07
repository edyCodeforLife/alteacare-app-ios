//
//  FacebookAnalyticsProvider.swift
//  Altea Care
//
//  Created by Hedy on 30/09/21.
//

import Foundation
import UIKit
import FBSDKCoreKit

class FacebookAnalyticsProvider: AnalyticsEngine {
    
    var identifier: String {
        return ""
    }
    
    func setup(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func setActiveSession(_ data: AnalyticsUserData) {

    }
    
    func setInactiveSession() {

    }
    
    func setUserAttribute(_ data: AnalyticsUserData) {
        
    }
    
    func setCustomAttribute(_ value: Any?, forKey: String) {
        
    }
    
    func trackEvent(name: String?, parameters: [String : Any]?) {
    }
    
    private func transformProperties(_ parameters: [String : Any]) -> [AppEvents.ParameterName: Any] {
        var param = [AppEvents.ParameterName: Any]()
        for (key, val) in parameters {
            let newKey = AppEvents.ParameterName(key)
            param[newKey] = val
        }
        return param
    }
    
}
