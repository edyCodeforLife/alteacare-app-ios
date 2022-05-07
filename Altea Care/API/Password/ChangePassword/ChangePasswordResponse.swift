//
//  ChangePasswordResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 30/04/21.
//

import Foundation

// MARK: - ChangePasswordResponse
struct ChangePasswordResponse: Codable {
    let status: Bool
    let message, data: String
    let version : String?
}
