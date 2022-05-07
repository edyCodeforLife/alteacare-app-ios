//
//  ChangeEmailVerifyResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation

struct ChangeEmailVerifyResponse : Codable {
    let status : Bool
    let message : String
//    let data : ChangeEmailVerifyResponseData?
}

struct ChangeEmailVerifyResponseData: Codable {
    let isRegistered, isVerified: Bool
    let accessToken, refreshToken: String
    let isEmailVerified, isPhoneVerified: Bool
    let deviceId: String

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
