//
//  LogoutResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

// MARK: - LogoutResponse
struct LogoutResponse: Codable {
    let status: Bool
    let message, data: String?
}

