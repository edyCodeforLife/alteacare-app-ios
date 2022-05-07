//
//  VerifyEmailBody.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation

//MARK: - Verify Email Body
struct VerifyEmailBody : Codable {
    let email : String?
    let otp : String
    let phone : String?
    
    enum CodingKeys: String, CodingKey{
        case email
        case otp
        case phone
    }
}
