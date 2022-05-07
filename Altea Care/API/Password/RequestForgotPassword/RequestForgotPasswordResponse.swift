//
//  RequestForgotPasswordResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/04/21.
//

import Foundation

struct RequestForgotPasswordResponse : Codable {
    let status : Bool?
    let message : String
    let version : String?
}

struct ForgotData: Codable {
    let type, username, canResendAt: String

    enum CodingKeys: String, CodingKey {
        case type, username
        case canResendAt
    }
}
