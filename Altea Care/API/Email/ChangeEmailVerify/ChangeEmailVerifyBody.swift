//
//  ChangeEmailVerifyBody.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation

struct ChangeEmailVerifyBody: Codable{
    let email : String
    let otp : String
}
