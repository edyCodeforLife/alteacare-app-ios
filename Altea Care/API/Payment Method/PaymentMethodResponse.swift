//
//  PaymentMethodResponse.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import Foundation

// MARK: - PaymentMethodResponse
struct PaymentMethodResponse: Codable {
    let status: Bool
    let message: String?
    let data: [PaymentMethodList]?
}

// MARK: - PaymentMethodList
struct PaymentMethodList: Codable {
    let type: String?
    let paymentMethods: [PaymentMethod]?

    enum CodingKeys: String, CodingKey {
        case type
        case paymentMethods
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    let code, name: String?
    let paymentMethodDescription: String?
    let provider: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case code, name
        case paymentMethodDescription = "description"
        case provider, icon
    }
}
