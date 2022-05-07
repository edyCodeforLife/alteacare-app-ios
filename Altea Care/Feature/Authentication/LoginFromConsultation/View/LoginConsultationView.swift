//
//  LoginConsultationView.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 22/07/21.
//

import Foundation

protocol LoginConsultationView: BaseView {
    var viewModel: LoginConsultationVM! { get set }
    var resgisterationTapped: (() -> Void)? { get set }
    var forgotPasswordTapped: (() -> Void)? { get set }
    var callCenterTapped: (() -> Void)? { get set }
    var nameDoctor: String! { get set }
    var photoDoctor: String! { get set }
}
