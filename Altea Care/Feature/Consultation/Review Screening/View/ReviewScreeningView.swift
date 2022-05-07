//
//  ReviewScreeningView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol ReviewScreeningView: BaseView {
    var viewModel: ReviewScreeningVM! { get set }
    var onReviewed: ((String) -> Void)? { get set }
    var onCanceled: (() -> Void)? { get set }
    var onClosed: (() -> Void)? { get set }
    var doctor: DoctorCardModel? { get set }
    var endTime: String? { get set }
    var appointmentId: String! { get set }
}
