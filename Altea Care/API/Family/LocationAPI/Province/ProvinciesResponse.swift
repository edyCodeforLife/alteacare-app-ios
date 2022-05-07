//
//  ProvinciesResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation

struct ProvinciesResponse : Codable{
    let status: Bool?
    let message: String?
    let data: [ProvinceData]
    let version : String?
}

// MARK: - Datum
struct ProvinceData: Codable {
    let provinceId, code, name: String?

    enum CodingKeys: String, CodingKey {
        case provinceId
        case code, name
    }
}
