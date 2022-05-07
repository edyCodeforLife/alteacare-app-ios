//
//  RequestChangePhoneNumberResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

struct RequestChangePhoneNumberResponse : Codable {
    let status: Bool
    let message: String
    let data: data?
}

struct data: Codable {
    let resendAt : String?
    let phone: String?
    enum CodingKeys: String, CodingKey {
        case resendAt = "can_resend_at"
        case phone
    }
}
