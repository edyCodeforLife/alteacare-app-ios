//
//  SubDistrictResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation

// MARK: - SubDistrictResponse
struct SubDistrictResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [SubDistrictData]
    let version : String?
}

// MARK: - Datum
struct SubDistrictData: Codable {
    let subDistrictId, name, postalCode, geoArea: String?
    let district: District
    let city: CitySubDustrictData
    let country: CountrySubDistrictData

    enum CodingKeys: String, CodingKey {
        case subDistrictId
        case name
        case postalCode
        case geoArea
        case district, city, country
    }
}

// MARK: - City
struct CitySubDustrictData: Codable {
    let cityId: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case cityId
        case name
    }
}

// MARK: - Country
struct CountrySubDistrictData: Codable {
    let countryId: String
    let name: String
    let code: String

    enum CodingKeys: String, CodingKey {
        case countryId
        case name, code
    }
}

struct District: Codable {
    let districtId: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case districtId
        case name
    }
}
