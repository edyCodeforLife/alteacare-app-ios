//
//  CheckEmailRegisterResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/08/21.
//

import Foundation


struct CheckEmailRegisterResponse: Codable {
    let status: Bool
    let message: String
    let data: CheckEmailRegisterData
}

// MARK: - DataClass
struct CheckEmailRegisterData: Codable {
    let isEmailAvailable, isPhoneAvailable: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEmailAvailable
        case isPhoneAvailable
    }
}

