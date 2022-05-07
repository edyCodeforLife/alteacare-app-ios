//
//  CountryResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 07/05/21.
//

import Foundation

struct CountryResponse: Codable {
    let status: Bool
    let message: String
    let data: [CountryResponseData]
}

// MARK: - Datum
struct CountryResponseData: Codable {
    let countryId, name, code: String

    enum CodingKeys: String, CodingKey {
        case countryId
        case name, code
    }
}
