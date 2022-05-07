//
//  HistoryConsultationView.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol HistoryConsultationView: BaseView {
    var viewModel: HistoryConsultationVM! { get set }
    var onConsultationTapped: ((HistoryConsultationModel) -> Void)? { get set }
}
