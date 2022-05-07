//
//  VaccineManager.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 30/12/21.
//

import Foundation

struct WebLinkManager {
    static func generateVacineUrl( url: String, email: String, token: String) -> String {
        let replacedUrlByEmail = url.replacingOccurrences(of: "{email}", with: email)
        let token = "&at=\(token)"
        return replacedUrlByEmail+token
    }
    
    static func checkWeblinkType(url: String) -> WebLinkType {
        if url.contains("vaccine") {
            return .vaccine
        } else {
            return .none
        }
    }
}

enum WebLinkType {
    case vaccine
    case none
}
