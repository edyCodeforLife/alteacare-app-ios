//
//  DetailMemberResponse.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation

// MARK: - DetailMemberResponse
struct DetailMemberResponse: Codable {
    let status: Bool
    let message: String
    let data: AddMemberData?
}
