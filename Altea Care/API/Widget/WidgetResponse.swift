//
//  HopmeWidgetResponse.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 29/12/21.
//

import Foundation

// MARK: - WIdgetResponse
struct WidgetResponse: Codable {
    let status: Bool
    let message: String
    let data: [Widget]
}

// MARK: - Datum
struct Widget: Codable {
    let id, title: String
    let ios: Platform
    let needLogin: Bool
    let weight: Int
}

// MARK: - Android
struct Platform: Codable {
    let icon: Icon
    let deeplinkType: String
    let deeplinkUrl: String
}
