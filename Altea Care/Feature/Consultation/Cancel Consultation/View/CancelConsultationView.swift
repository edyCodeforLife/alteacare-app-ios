//
//  CancelConsultationView.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol CancelConsultationView: BaseView {
    var viewModel: CancelConsultationVM! { get set }
    var onConsultationTapped: ((CancelConsultationModel) -> Void)? { get set }
}
