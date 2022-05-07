//
//  ChangePasswordBody.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 30/04/21.
//

import Foundation

struct ChangePasswordBody: Codable {
    let password, password_confirmation: String

    enum CodingKeys: String, CodingKey {
        case password
        case password_confirmation
    }
}
