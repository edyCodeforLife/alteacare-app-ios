//
//  ReceiptModel.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import UIKit

struct ReceiptModel {
    let item: [ReceiptModelDetail]
    let totalPrice: String?
}

struct ReceiptModelDetail {
    let title: String?
    let contents: [ReceiptSections]
}

enum ReceiptSections {
    case consultation(ConsultationFeeModel)
    case medicines(MedicinesModel)
    case delivery(RecipientModel)
//    case payment(PaymentsModel)
    
    func getTotalPrice() -> Double {
        switch self {
        case .consultation(let model):
            return model.priceInNumber
        default:
            return 0.0
        }
    }
}

struct ConsultationFeeModel {
    let name: String?
    let isHighlighted: Bool
    let price: String?
    let paymentMethod: PaymentsModel
    let image: UIImage?
    let fees : [InquiryPaymentFeeModel]
    let priceInNumber: Double
}

struct MedicinesModel {
    let name: String?
    let price: String?
}

struct RecipientModel {
    let name: String?
    let phone: String?
    let address: String?
    let courier: String?
    let fee: String?
}

struct PaymentsModel {
    let bank: String?
    let type: String?
    let detail: DetailPaymentModel
}

struct DetailPaymentModel {
    let name: String?
    let icon : String?
}
