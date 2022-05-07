//
//  SetDefaultMemberResponse.swift
//  Altea Care
//
//  Created by Tiara on 03/09/21.
//

import Foundation
struct SetDefaultMemberResponse: Codable {
    let status: Bool
    let message: String
    let data: String
    
    enum CodingKeys: String, CodingKey {
        case status, message
        case data
    }
}
