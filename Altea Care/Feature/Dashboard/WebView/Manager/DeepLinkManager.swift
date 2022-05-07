//
//  DeepLinkManager.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 30/12/21.
//

import Foundation

enum DeepLinkType {
    case teleconsultation
    case none
}

struct DeeplinkManager {
    static func checkDeeplinkType(url: String) -> DeepLinkType {
        if url.contains("home/telekonsultasi") {
            return .teleconsultation
        } else {
            return .none
        }
    }
}
