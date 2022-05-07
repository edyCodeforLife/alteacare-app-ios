//
//  CheckOldPasswordResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

struct CheckOldPasswordResponse : Codable {
    let status: Bool
    let message: String
    let data: String
    let version : String?
}
