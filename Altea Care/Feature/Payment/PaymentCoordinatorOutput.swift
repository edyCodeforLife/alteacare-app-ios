//
//  PaymentCoordinatorOutput.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol PaymentCoordinatorOutput {
    var onPaymentReviewed: (() -> Void)? { get set }
    var onPaymentCanceled: (() -> Void)? { get set }
    var onPaymentVerification: (() -> Void)? { get set }
    var idAppointment: String! { get set }
    var onGoDashboard: (() -> Void)? { get set }
}
