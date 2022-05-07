//
//  HomeView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol HomeView: BaseView {
    var viewModel: HomeVM! { get set }
    var onTappedListDoctorSpecialization: ((String, String, Bool) -> Void)? { get set }
    var onSignInTapped: (() -> Void)? { get set }
    var onConsultationCallingTapped: ((Int, String?, Bool) -> Void)? { get set }
    var onSearchAutocomplete: (() -> Void)? { get set }
    var onGoToRegister: (() -> Void)? { get set }
    var onGotoWebView : ((String, Bool) -> Void)? { get set }
    var onChangeAccount: ((_ data : [UserCredential]) -> Void)? { get set }
    var onGoToForceUpdate: (() -> Void)? { get set }
    var onOutsideOperatingHour: ((SettingModel)->Void)? { get set }
    var onGoToDoctorSpecialist: (() -> Void)? { get set }
    var onConsultationTapped: ((String, ConsultationStatus) -> Void)? {get set}
    var onPaymentMethodTapped: ((String) -> Void)? {get set}
    var onPaymentContinueTapped: ((String, Int) -> Void)? {get set}

}
