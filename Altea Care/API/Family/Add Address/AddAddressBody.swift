//
//  AddAddressBody.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation

// MARK: - AddAddressBody
struct AddAddressBody: Codable {
    let street, country, province: String?
    let city, district, subDistrict, rtRw: String?

    enum CodingKeys: String, CodingKey {
        case street, country, province, city, district
        case subDistrict = "sub_district"
        case rtRw = "rt_rw"
    }
}
