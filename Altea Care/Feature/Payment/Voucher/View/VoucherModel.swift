//
//  VoucherModel.swift
//  Altea Care
//
//  Created by Tiara on 11/09/21.
//

import Foundation
struct VoucherModel {
    let status: Bool
    let voucher: VoucherData?
}

struct VoucherData{
    let voucherCode: String
    let afterDiscountPrice: Price
    let discount: Price
    
}
