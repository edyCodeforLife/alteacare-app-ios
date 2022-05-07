//
//  ChangePhoneNumberBody.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

struct ChangePhoneNumberBody : Codable {
    let phone : String
    let otp : String
}
