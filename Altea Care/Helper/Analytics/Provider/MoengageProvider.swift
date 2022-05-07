//
//  MoengageProvider.swift
//  Altea Care
//
//  Created by Hedy on 11/09/21.
//

import Foundation
import MoEngage

class MoengageProvider: AnalyticsEngine {
    
    private var provider: MoEngage {
        return MoEngage.sharedInstance()
    }
    
    var identifier: String {
        #if DEBUG
        return "R7W0R9X4WBKPHN69TC12KV7U"
        #else
        return "R7W0R9X4WBKPHN69TC12KV7U"
        #endif
    }
    
    var appGroupID: String {
        #if DEBUG
        return "group.com.mitrakeluarga.AlteaCare.debuging.MoEngage"
        #else
        return "group.com.mitrakeluarga.AlteaCare.production.MoEngage"
//        return "group.com.mitrakeluarga.AlteaCare.debuging.MoEngage"
        #endif

    }
    
    func setup(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        var config = MOSDKConfig.init(appID: identifier)
        config.appGroupID = appGroupID
        // Separate initialization methods for Dev and Prod initializations
        #if DEBUG
        provider.initializeTest(with: config, andLaunchOptions: launchOptions)
        #else
//        provider.initializeLive(with: config, andLaunchOptions: launchOptions)
        provider.initializeTest(with: config, andLaunchOptions: launchOptions)
        #endif
        
        provider.registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: self)
    }
    
    func setActiveSession(_ data: AnalyticsUserData) {
        provider.setUserUniqueID(data.id)
    }
    
    func setInactiveSession() {
        provider.resetUser()
    }
    
    func setUserAttribute(_ data: AnalyticsUserData) {
        provider.setAlias(data.id)
        provider.setUserName(data.name)
        provider.setUserEmailID(data.email)
        provider.setUserMobileNo(data.mobilePhone)
        if let gender = self.transformGender(data.gender) {
            provider.setUserGender(gender)
        }
        provider.setUserDateOfBirth(data.birthDate)
        provider.setUserAttribute(data.age, forKey: "age")
        //provider.setUserAttribute(data.city, forKey: "city")
        provider.setUserAttribute(data.isPregnant, forKey: "Is_Pregnant")
    }
    
    private func transformGender(_ gender: String?) -> UserGender? {
        guard let gender = gender else { return nil }
        if gender == "Laki-laki" {
            return MALE
        } else if gender == "Perempuan" {
            return FEMALE
        }
        return OTHER
    }
    
    func setCustomAttribute(_ value: Any?, forKey: String) {
        provider.setUserAttribute(value, forKey: forKey)
    }
    
    func trackEvent(name: String?, parameters: [String : Any]?) {
        guard let name = name else { return }
        provider.trackEvent(name, with: self.transformProperties(parameters))
    }
    
    private func transformProperties(_ parameters: [String : Any]?) -> MOProperties? {
        guard let parameters = parameters else { return nil }
        return MOProperties(attributes: NSMutableDictionary(dictionary: parameters))
    }
    
}
