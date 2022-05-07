//
//  LoginResponse.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

struct LoginResponse: Codable {
    let version : String?
    let status : Bool?
    let message : String?
    let data : LoginData?
}

struct LoginData : Codable {
    let isRegistered, isVerified: Bool?
    let accessToken, refreshToken: String?
    let isEmailVerified, isPhoneVerified: Bool?
    let deviceID: String?
    
    enum CodingKeys: String, CodingKey {
        case isRegistered
        case isVerified
        case accessToken
        case refreshToken
        case isEmailVerified
        case isPhoneVerified
        case deviceID 
    }
}
