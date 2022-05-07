//
//  AnalyticsProvider.swift
//  Altea Care
//
//  Created by Hedy on 11/09/21.
//

import Foundation
import UIKit

protocol AnalyticsEngine {
    var identifier: String { get }
    func setup(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func setActiveSession(_ data: AnalyticsUserData)
    func setInactiveSession()
    func setUserAttribute(_ data: AnalyticsUserData)
    func setCustomAttribute(_ value: Any?, forKey: String)
    func trackEvent(name: String?, parameters: [String: Any]?)
}

extension AnalyticsEngine {
    func transformLimit(_ parameter: [String: Any]?) -> [String: Any]? {
        guard let parameter = parameter else {
            return nil
        }
        
        var result = parameter
        for (key, value) in parameter {
            if let str = value as? String {
                result[key] = String(str.prefix(100))
            }
        }
        return result
    }
}

enum AnalyticsCustomAttributes: String {
    case lastDoctorChatName = "Last_Doctor_Chat_Name"
    case lastConsultationDate = "Last_Consultation_Date"
    case lastDiagnosedDisease = "Last_Diagnosed_Disease"
    case lastSearch = "Last_Search"
    case lastSpecialistPick = "Last_Specialist_Pick"
    case lastOpenTime = "Last_Open_Time"
    case lastHospitalPick = "Last_Hospital_Pick"
}

enum AnalyticsProvider: CaseIterable {
    case moengage
    case facebook
    case firebase
    
    func getEngine() -> AnalyticsEngine {
        switch self {
        case .moengage:
            return MoengageProvider()
        case .facebook:
            return FacebookAnalyticsProvider()
        case .firebase:
            return FirebaseAnalyticsProvider()
        }
    }
}
