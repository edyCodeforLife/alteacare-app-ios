//
//  RegisterResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/03/21.
//

import Foundation

struct RegisterResponse: Codable {
    let status: Bool?
    let message: String
    let data: ResponseData?
    let version : String?
}

// MARK: - DataClass
struct ResponseData: Codable {
    let isRegistered, isVerified: Bool?
    let accessToken, refreshToken: String?
    let isEmailVerified, isPhoneVerified: Bool?
    let deviceId: String?

    enum CodingKeys: String, CodingKey {
        case isRegistered
        case isVerified
        case accessToken
        case refreshToken
        case isEmailVerified
        case isPhoneVerified
        case deviceId
    }
}
