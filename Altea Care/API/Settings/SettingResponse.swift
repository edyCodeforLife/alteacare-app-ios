//
//  SettingResponse.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 28/11/21.
//

import Foundation

// MARK: - SetingResponse
struct SettingResponse: Codable {
    let status: Bool
    let message: String
    let data: SettingData?
}

// MARK: - DataClass
struct SettingData: Codable {
    let operationalHourStart, operationalHourEnd: String
    let operationalWorkDay: [String]
    let firstDelaySocketConnect: Int
    let delaySocketConnect: Int
}
