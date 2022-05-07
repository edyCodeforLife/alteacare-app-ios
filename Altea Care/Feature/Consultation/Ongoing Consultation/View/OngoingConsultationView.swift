//
//  OngoingConsultationView.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol OngoingConsultationView: BaseView {
    var viewModel: OngoingConsultationVM! { get set }
    var onConsultationTapped: ((OngoingConsultationModel) -> Void)? { get set }
    var onConsultationCallingTapped: ((Int, String?, Bool) -> Void)? { get set }
    var onPaymentMethod:((String) -> Void)? { get set }
    var onPaymentTapped: ((String, Int) -> Void)? { get set }
    var onOutsideOperatingHour: ((SettingModel)->Void)? { get set }
}
