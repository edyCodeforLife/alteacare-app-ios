//
//  AccountFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

extension ModuleFactoryImpl: AccountFactory {
    
    func makeVerifyChangeEmailAccount(newEmail: String, oldEmail: String) -> VerifyChangeEmailView {
        let vc = VerifyChangeEmailVC()
        vc.newEmail = newEmail
        vc.oldEmail = oldEmail
        vc.viewModel = makeVerifyChangeEmailVM()
        vc.changeEmailVM = makeChangeEmailVM()
        return vc
    }
    
    func makeAccount() -> AccountView {
        let vc = AccountVC()
        vc.viewModel = makeAccountVM()
        return vc
    }
    
    func makeTermCondition() -> TermConditionView {
        let vc = TermConditionViewController()
        vc.viewModel = makeTermConditionAccountVM()
        return vc
    }
    
    func makeContactUs() -> ContactUsView {
        let vc = ContactUsVC()
        vc.viewModel = makeContactUsVM()
        return vc
    }
    
    func makeFaq() -> FaqView {
        let vc = FaqVC()
        vc.viewModel = makeFaqVM()
        return vc
    }
    
    func makeChangePersonalData() -> ChangePersonalDataView {
        let vc = ChangePersonalDataVC()
        vc.viewModel = makeChangePersonalDataVM()
        return vc
    }
    
    func makeInitialChangeProfile() -> ChangeProfileView {
        let vc = ChangeProfileVC()
        vc.viewModel = makeInitialChangeProfileVM()
        return vc
    }
    
    func makeInitialChangePhoneNumber() -> InitialChangePhoneNumberView {
        let vc = InitialChangePhoneNumberVC()
        vc.viewModel = makeInitialChangePhoneNumberVM()
        return vc
    }
    
    func makeVerifyPhoneNumber() -> VerifyPhoneNumberView {
        let vc = VerifyPhoneNumberVC()
        vc.viewModel = makeVerifyPhoneNumberVM()
        return vc
    }
    
    func makeInitialSettingAccount() -> InitialSetAccountView {
        let vc = InitialSetAccountVC()
        vc.viewModel = makeInitialSetAccountVM()
        return vc
    }
    
    func makeInitalSettingAccount() -> InitialSetAccountView {
        let vc = InitialSetAccountVC()
        vc.viewModel = makeInitialSetAccountVM()
        return vc
    }
    
    func makeChangePassword() -> ChangePasswordView {
        let vc = ChangePasswordVC()
        vc.viewModel = makeChangePasswordVM()
        return vc
    }
    
    func makeAccountView() -> AccountView {
        let vc = AccountVC()
        vc.viewModel = makeAccountVM()
        return vc
    }
    
    func makeOldPassword() -> OldPasswordView {
        let vc =  OldPasswordVC()
        vc.viewModel = makeOldPasswordVM()
        return vc
    }
    
    func makeInitialChangeEmail(email: String) -> ChangeEmailAccountView {
        let vc = ChangeEmailAccountVC()
        vc.email = email
        vc.viewModel = makeChangeEmailVM()
        return vc
    }
    
}
