//
//  RegisterModel.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 12/03/21.
//

import Foundation

struct RegisterModel {
    let status: Bool?
    let message: String?
    let data: RegisterModelData?
}

// MARK: - DataClass
struct RegisterModelData {
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



