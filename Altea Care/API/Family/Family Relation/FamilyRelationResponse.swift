//
//  FamilyRelationResponse.swift
//  Altea Care
//
//  Created by Tiara on 02/09/21.
//

import Foundation

struct FamilyRelationResponse: Codable {
    let status: Bool
    let message: String
    let data: [FamilyRelationResponseData]
    
    enum CodingKeys: String, CodingKey {
        case status, message
        case data
    }
}

// MARK: - Datum
struct FamilyRelationResponseData: Codable {
    let id, name: String
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case isDefault 
    }
}
