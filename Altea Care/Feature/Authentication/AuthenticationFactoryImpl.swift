//
//  AuthenticationFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

extension ModuleFactoryImpl: AuthenticationFactory {
    
//    func makeSuccessRegisterView() -> SuccessRegisterView {
//        let vc = SuccessRegisterVC()
//        return vc as! SuccessRegisterView
//    }
//    
//    func makeRegistrationSuccessAnimationView() -> RegistrationSuccessAnimationView {
//        let vc = RegistrationSuccesAnimationVC()
//        return vc as! RegistrationSuccessAnimationView
//    }
//    
    
    func makeTermAndConditionView() -> TermAndConditionView {
        let vc = TermConditionCheckVC()
        vc.viewModel = makeTermConditionVM()
        return vc
    }
    
    
    func makeEmailVerification() -> EmailVerificationView {
        let vc = VerificationEmailVC()
        vc.viewModel = makeEmailVerificationVM()
        return vc
    }
    
    
    func makeLoginView() -> LoginView {
        let vc = LoginVC()
        vc.viewModel = makeLoginVM()
        return vc
    }
    
    func makeRegisterView() -> RegisterView {
        let vc = RegisterVC()
        vc.viewModelRegister = makeRegisterVM()
        return vc
    }
    
    func makeRegisterReviewView() -> RegisterReviewView {
        let vc = RegisterReviewVC()
        vc.viewModelRegisterReview = makeRegisterReviewVM()
        return vc
    }
    
    func makeContactFieldView() -> ContactFieldView {
        let vc = ContactFieldVC()
        vc.viewModel = makeContactFieldVM()
        return vc
    }
    
    func makeCreatePasswordView() -> CreatePasswordView {
        let vc = CreatePasswordVC()
        vc.viewModel = makeCreatePasswordVM()
        return vc
    }
    
    func makeChangeEmailAddressView() -> ChangeEmailAddressView {
        let vc = ChangeEmailAddressVC()
        vc.viewModel = makeChangeEmailAddressVM()
        return vc
    }
    
    func makeForgotPasswordView() -> ForgotPasswordView {
        let vc = ForgotPasswordVC()
        vc.viewModel = makeInitialForgotPasswordVM()
        return vc
    }
    
    func makeReverificationEmailView() -> ReverificationEmailView {
        let vc = ReverificationEmailVC()
        vc.viewModel = makeReverificationEmailVM()
        return vc
    }
    
    func makeCreateNewPasswordView() -> CreateNewPasswordView {
        let vc = CreateNewPasswordVC()
        vc.viewModel = makeCreateNewPasswordVM()
        return vc
    }
    
    func makeRegisterSuccedView() -> SuccessRegisterView {
        let vc = SuccessRegisterVC()
        vc.viewModel = makeSuccessRegisterVM()
        return vc
    }
    
    func makeContactUsView() -> ContactUsView {
        let vc = ContactUsVC()
        vc.viewModel = makeContactUsVM()
        return vc
    }
}
