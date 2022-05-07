//
//  LoginView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol LoginView: BaseView {
    var viewModel: LoginVM! { get set }
    var photoDoctor: String? { get set }
    var doctor: String? { get set }
    var onLoginSucceed: (() -> Void)? { get set }
    var onDaftarTapped: (() -> Void)? { get set }
    var needHelpTapped: (() -> Void)? { get set }
    var forgotKataSandi: (() -> Void)? { get set }
    var onVerifiedAccount: ((VerificationType) -> Void)? { get set}
}
