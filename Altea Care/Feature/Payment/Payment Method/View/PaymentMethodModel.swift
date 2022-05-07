//
//  PaymentMethodModel.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import Foundation
struct PaymentMethodModel {
    let type: String
    let paymentMethod: [PaymentMethodModelItem]
}
struct PaymentMethodModelItem {
    let code: String
    let name: String
    let desc: String
    let icon: String
}
