//
//  ForceUpdateResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/09/21.
//

import Foundation


// MARK: - SubDistrictResponse
struct ForceUpdateResponse: Codable {
    let status: Bool?
    let message: String
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let isUpdateRequired: Bool?
    let latest: Latest?
}

// MARK: - Latest
struct Latest: Codable {
    let platform, version: String?
    let versionCode: Int?

    enum CodingKeys: String, CodingKey {
        case platform, version
        case versionCode
    }
}
