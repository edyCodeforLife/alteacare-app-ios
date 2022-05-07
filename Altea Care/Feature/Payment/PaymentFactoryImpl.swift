//
//  PaymentFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

extension ModuleFactoryImpl: PaymentFactory {
    
    func makeInquiryPayment() -> InquiryPaymentView {
        let vc = InquiryPaymentVC()
        vc.viewModel = makeInquiryPaymentVM()
        return vc
    }
    
    func makePaymentMethod() -> PaymentMethodView {
        let vc = PaymentMethodVC()
        vc.viewModel = makePaymentMethodVM()
        return vc
    }
    
    func makeReviewPayment() -> ReviewPaymentView {
        let vc = ReviewPaymentVC()
        vc.viewModel = makeReviewPaymentVM()
        return vc
    }
    
    func makeWebViewMethod() -> AlteaPaymentVAView {
        let vc = AlteaPaymentWebviewVC()
        vc.viewModel = makeWebViewAlteaVM()
        return vc
    }
    
    func makeVoucherView() -> VoucherView {
        let vc = VoucherVC()
        vc.viewModel = makeVoucherVM()
        return vc
    }
    
    func makeCloseConfirmationView() -> ClosePaymentConfirmationView {
        let vc = ClosePaymentConfirmationVC()
        return vc
    }
}
