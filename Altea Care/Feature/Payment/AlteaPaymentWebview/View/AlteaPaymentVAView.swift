//
//  AlteaPaymentVAView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 28/06/21.
//

import Foundation

protocol AlteaPaymentVAView : BaseView {
    var viewModel: AlteaPaymentWebViewVM! { get set }
    var paymentUrl : String! { get set }
    var appointmentId : Int! { get set }
    var checkStatusPaymentTappedPayed: ((Int) -> Void)? { get set }
    var onBackTapped: (() -> Void)? {get set}
}
