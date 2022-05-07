//
//  VoucherResponse.swift
//  Altea Care
//
//  Created by Tiara on 11/09/21.
//

import Foundation


struct VoucherResponse: Codable {
    let status: Bool
    let message: String
    let data: VoucherItem?
}

// MARK: - DataClass
struct VoucherItem: Codable {
    let voucherCode: String?
    let discount, grandTotal, total: Price

    enum CodingKeys: String, CodingKey {
        case voucherCode
        case discount
        case grandTotal
        case total
    }
}

