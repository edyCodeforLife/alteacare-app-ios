//
//  RefreshTokenBody.swift
//  Altea Care
//
//  Created by Hedy on 23/03/21.
//

import Foundation

struct RefreshTokenBody: Codable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
