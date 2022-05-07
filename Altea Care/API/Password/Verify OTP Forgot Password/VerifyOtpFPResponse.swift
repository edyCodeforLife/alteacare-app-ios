//
//  VerifyOTPForgotPasswordResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 30/04/21.
//

import Foundation

struct VerifyOtpFPResponse: Codable {
    let status: Bool?
    let message: String
    let data: VerifyOTPData?
    let version : String?
}

// MARK: - DataClass
struct VerifyOTPData: Codable {
    let isRegistered, isVerified: Bool?
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
