//
//  ReviewPaymentView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol ReviewPaymentView: BaseView {
    var viewModel: ReviewPaymentVM! { get set }
    var onPaymentReviewed: (() -> Void)? { get set }
    var goDashboard : (() -> Void)? { get set }
    var appointmentId : Int! { get set }
    var isRoot : Bool { get set }
}
