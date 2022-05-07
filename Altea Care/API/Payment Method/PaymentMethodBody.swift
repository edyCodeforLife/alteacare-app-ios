//
//  PaymentMethodBody.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import Foundation

struct PaymentMethodBody: Codable {
    let voucher_code : String
    let transaction_id : Int
    let type_of_service: String
}
