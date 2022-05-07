//
//  FirebaseAnalyticsProvider.swift
//  Altea Care
//
//  Created by Hedy on 30/09/21.
//

import Foundation
import UIKit
import FirebaseAnalytics

class FirebaseAnalyticsProvider: AnalyticsEngine {
    
    var identifier: String {
        //no need identifier, since the credential put in plist file and loaded in AppDelegate
        return ""
    }
    
    func setup(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        //no need setup in here, we put in AppDelegate + BuildPhases
    }
    
    func setActiveSession(_ data: AnalyticsUserData) {
        Analytics.setUserID(data.id)
    }
    
    func setInactiveSession() {
        
    }
    
    func setUserAttribute(_ data: AnalyticsUserData) {
        Analytics.setUserProperty(data.id, forName: "user_id")
        Analytics.setUserProperty(data.name, forName: "name")
        Analytics.setUserProperty(data.email, forName: "email")
        Analytics.setUserProperty(data.mobilePhone, forName: "mobile_number")
        Analytics.setUserProperty(data.gender, forName: "gender")
        Analytics.setUserProperty(data.birthDate?.dateIndonesia(), forName: "birth_date")
        Analytics.setUserProperty("\(data.age ?? 0)", forName: "age")
        //Analytics.setUserProperty(data.city, forName: "city")
        Analytics.setUserProperty(data.isPregnant ?? false ? "true" : "false", forName: "Is_Pregnant")
    }
    
    func setCustomAttribute(_ value: Any?, forKey: String) {
        Analytics.setUserProperty(value as? String, forName: forKey)
    }
    
    func trackEvent(name: String?, parameters: [String : Any]?) {
        guard let name = name else { return }
        Analytics.logEvent(name, parameters: self.transformLimit(parameters))
    }
    
}
