//
//  SendVerificationEmailBody.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation

//MARK: - Send verification email body
struct SendVerificationEmailBody : Codable {
    let email : String?
    let phone: String?
}
