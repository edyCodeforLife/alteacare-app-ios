//
//  DistrictResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation

struct DistrictResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [DistrictData]
    let version : String?
}

// MARK: - Datum
struct DistrictData: Codable {
    let districtId, name: String?
    let city: CityDistrictData

    enum CodingKeys: String, CodingKey {
        case districtId
        case name, city
    }
}

// MARK: - City
struct CityDistrictData: Codable {
    let cityId, name: String

    enum CodingKeys: String, CodingKey {
        case cityId
        case name
    }
}
