//
//  PaymentMethodView.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import Foundation

protocol PaymentMethodView: BaseView {
    var viewModel: PaymentMethodVM! { get set }
    var consultationId: Int! { get set }
    var voucherCode: VoucherBody? { get set }
    var goToWebView: ((String, Int) -> Void)? { get set }
    var goToReview: ((Int) -> Void)? { get set }
//    var goToWebView: ((String) -> Void)? { get set }
}
