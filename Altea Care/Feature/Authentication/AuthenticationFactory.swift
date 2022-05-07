//
//  AuthenticationFactory.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol AuthenticationFactory {
    func makeLoginView() -> LoginView
    func makeRegisterView() -> RegisterView
    func makeRegisterReviewView() -> RegisterReviewView
    func makeContactFieldView() -> ContactFieldView
    func makeCreatePasswordView() -> CreatePasswordView
    func makeTermAndConditionView() -> TermAndConditionView
    func makeChangeEmailAddressView() -> ChangeEmailAddressView
    func makeEmailVerification() -> EmailVerificationView
    func makeForgotPasswordView() -> ForgotPasswordView
    func makeReverificationEmailView() -> ReverificationEmailView
    func makeCreateNewPasswordView() -> CreateNewPasswordView
    func makeRegisterSuccedView() -> SuccessRegisterView
    func makeContactUsView() -> ContactUsView
//    func makeSuccessRegisterView() -> SuccessRegisterView
//    func makeRegistrationSuccessAnimationView() -> RegistrationSuccessAnimationView
}
