//
//  ListAddressResponse.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation

// MARK: - ListAddressResponse
struct ListAddressResponse: Codable {
    let status: Bool?
    let message: String?
    let data: ListAddressData?
    let version : String?
}

// MARK: - DataClass
struct ListAddressData: Codable {
    let meta: Meta?
    let address: [Address]
}

// MARK: - Address
struct Address: Codable {
    let id, type, street, rtRw: String?
    let country: LocationData?
    let province: LocationData?
    let city, district: LocationData?
    let subDistrict: LocationData?
    let latitude, longitude: String?

    enum CodingKeys: String, CodingKey {
        case id, type, street
        case rtRw
        case country, province, city, district
        case subDistrict 
        case latitude, longitude
    }
}

// MARK: - Country
struct LocationData: Codable {
    let id, code, name: String?
}
