//
//  AnalyticsEngine.swift
//  Altea Care
//
//  Created by Hedy on 10/09/21.
//

import Foundation
import UIKit

class AnalyticsService {
    
    private var engines: [AnalyticsEngine]
    private var providers: [AnalyticsProvider]
    
    init(_ providers: [AnalyticsProvider]) {
        self.providers = providers
        self.engines = providers.map { $0.getEngine() }
    }
    
    init(_ provider: AnalyticsProvider) {
        self.providers = [provider]
        self.engines = [provider.getEngine()]
    }
    
    static func setup(_ provider: AnalyticsProvider, application: UIApplication, with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        provider.getEngine().setup(application: application, launchOptions: launchOptions)
    }
    
    static func setupMultiple(_ providers: [AnalyticsProvider], application: UIApplication, with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        providers.forEach { $0.getEngine().setup(application: application, launchOptions: launchOptions) }
    }
    
    func active(_ userData: AnalyticsUserData) {
        engines.forEach { $0.setUserAttribute(userData) }
        engines.forEach { $0.setActiveSession(userData) }
    }
    
    func inactive() {
        engines.forEach { $0.setInactiveSession() }
    }
    
    func trackUserAttribute(_ value: Any?, key: String) {
        engines.forEach { $0.setCustomAttribute(value, forKey: key) }
    }
    
    func trackEvent(_ tracker: AnalyticsEventTracker) {
        for (idx, engine) in engines.enumerated() {
            let name = tracker.getName(self.providers[idx])
            let param = tracker.getParameter(self.providers[idx])
            if let param = param {
                engine.trackEvent(name: name, parameters: param.dictionaryWithConvert)
            } else {
                engine.trackEvent(name: name, parameters: nil)
            }
        }
    }
}

extension UIViewController {
    
    var defaultAnalyticsService: AnalyticsService {
        AnalyticsService(AnalyticsProvider.allCases)
    }
    
    func track(_ tracker: AnalyticsEventTracker) {
        defaultAnalyticsService.trackEvent(tracker)
    }
}
