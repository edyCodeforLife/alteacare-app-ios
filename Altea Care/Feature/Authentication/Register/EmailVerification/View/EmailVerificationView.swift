//
//  EmailVerificationView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation

protocol EmailVerificationView : BaseView {
    var state : VerificationType! { get set}
    var isFromLogin : Bool! { get set}
    var viewModel : EmailVerificationVM! { get set}
    var onEmailVerificationSuccedd : (() -> Void)? { get set }
    var onChangeEmailAddress : ((VerificationType) -> Void)? { get set }
    var goToRegisterSuccedd : (() -> Void)? { get set }
}
