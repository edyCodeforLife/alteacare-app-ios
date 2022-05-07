//
//  SendVerificationEmailResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation

//MARK: - response request verification email
struct SendVerificationEmailResponse : Codable {
    let status : Bool?
    let message : String?
    let data : VerificationData?
}

struct VerificationData : Codable {
    let canResendAt : String
    let email : String?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case canResendAt
        case email
        case phone
    }
}
