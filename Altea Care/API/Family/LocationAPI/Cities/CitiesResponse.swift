//
//  CitiesResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation

// MARK: - CitiesResponse
struct CitiesResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [CityData]
    let version : String?
}

// MARK: - Datum
struct CityData: Codable {
    let cityId, name: String?
    let country, province: CountryProvinceVessel

    enum CodingKeys: String, CodingKey {
        case cityId
        case name, country, province
    }
}

// MARK: - Country
struct CountryProvinceVessel: Codable {
    let id: String
    let code: String
    let name: String
}
