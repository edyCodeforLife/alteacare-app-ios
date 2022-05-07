//
//  RefreshTokenResponse.swift
//  Altea Care
//
//  Created by Hedy on 23/03/21.
//

import Foundation

struct RefreshTokenResponse: Codable {
    let status: Bool
    let message: String
    let data: RefreshTokenModel?
}

struct RefreshTokenModel: Codable{
    let accessToken, refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken 
    }
}
