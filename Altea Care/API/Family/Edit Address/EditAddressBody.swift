//
//  EditAddressBody.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation

struct EditAddressBody: Codable {
    let street, country, province: String
    let city, district, sub_district, rt_rw: String

    enum CodingKeys: String, CodingKey {
        case street, country, province, city, district
        case sub_district
        case rt_rw
    }
}
