//
//  PatientDataView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol PatientDataView: BaseView {
    var onConsultation: ((String, Bool) -> Void)? { get set }
    var viewModel: PatientDataVM! { get set }
    var id: String! { get set }
    var status: ConsultationStatus! { get set }
    var onCountdownShow: ((Schedule) -> Void)? { get set}
    var onConsultationCallingTapped: ((Int, String) -> Void)? { get set}
}
