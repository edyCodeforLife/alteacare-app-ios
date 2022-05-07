//
//  VoucherView.swift
//  Altea Care
//
//  Created by Tiara on 11/09/21.
//

import Foundation
protocol VoucherView: BaseView {
    var viewModel: VoucherVM! { get set }
    var voucherOnUsed: ((VoucherModel) -> Void)? { get set } //passing voucher
    var transactionId: String! { get set }
}
