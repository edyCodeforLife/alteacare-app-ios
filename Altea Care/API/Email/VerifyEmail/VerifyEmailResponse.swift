//
//  VerifyEmailResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation

//MARK: - Response Verify Email OTP
struct VerifyEmailResponse : Codable {
    let status : Bool?
    let message : String?
    let data : VerifyData?
}

struct VerifyData: Codable {
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
