//
//  VerifyOTPForgotPassword.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 30/04/21.
//

import Foundation

struct VerifyOTPForgotPasswordBody : Codable {
    let username : String
    let otp : String
    
    enum CodingKeys: String, CodingKey{
        case username
        case otp
    }
}
