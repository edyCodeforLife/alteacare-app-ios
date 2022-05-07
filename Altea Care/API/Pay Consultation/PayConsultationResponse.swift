//
//  PayConsultationResponse.swift
//  Altea Care
//
//  Created by Hedy on 12/05/21.
//

import Foundation

struct PayConsultationResponse: Codable {
    let status: Bool
    let message: String?
    let data: PayConsultation?
}

struct PayConsultation: Codable {
    let bank : String?
    let expiredAt : String?
    let token: String?
    let redirectUrl: String?
    let paymentUrl: String?
    let total: Int?
    let type: String?
    let refId: String?
    
    enum CodingKeys : String, CodingKey {
        case bank
        case expiredAt
        case token
        case redirectUrl
        case paymentUrl
        case total
        case type
        case refId
    }
}
