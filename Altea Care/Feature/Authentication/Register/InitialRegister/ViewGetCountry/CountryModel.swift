//
//  CountryModel.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 07/05/21.
//

import Foundation

struct CountryModel {
    let status: Bool
    let message: String
    let data: [CountryData]
}

// MARK: - Datum
struct CountryData{
    let countryId : String
    let name : String

    enum CodingKeys: String, CodingKey {
        case countryId
        case name
    }
}
