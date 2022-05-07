//
//  InquiryPaymentView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol InquiryPaymentView: BaseView {
    var viewModel: InquiryPaymentVM! { get set }
    var consultationId: String! { get set }
    var onInquiry: ((Int) -> Void)? { get set }
    var onClosed: (() -> Void)? { get set }
    var onMethodTapped: ((Int,VoucherBody?) -> Void)? { get set }
    var onApplyVoucher: ((String) -> Void)? { get set }
    var voucherUsed : VoucherModel? { get set }
}
