//
//  PaymentFactory.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol PaymentFactory {
    func makeInquiryPayment() -> InquiryPaymentView
    func makeReviewPayment() -> ReviewPaymentView
    func makePaymentMethod() -> PaymentMethodView
    func makeWebViewMethod() -> AlteaPaymentVAView
    func makeHomeView() -> HomeView
    func makeVoucherView() -> VoucherView
    func makeCloseConfirmationView() -> ClosePaymentConfirmationView
}
