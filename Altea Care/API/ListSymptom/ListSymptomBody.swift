//
//  ListSymptomBody.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 27/11/21.
//

import Foundation

struct ListSymptomBody : Codable {
    let querySearch: String
    let limit: Int
    
    enum CodingKeys: String, CodingKey {
        case querySearch = "_q"
        case limit = "_limit"
    }
}


