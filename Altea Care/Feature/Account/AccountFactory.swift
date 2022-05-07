//
//  AccountFactory.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol AccountFactory {
    func makeAccount() -> AccountView
    func makeChangePassword() -> ChangePasswordView
    func makeOldPassword() -> OldPasswordView
    func makeTermCondition() -> TermConditionView
    func makeContactUs() -> ContactUsView
    func makeFaq() -> FaqView
    func makeChangePersonalData() -> ChangePersonalDataView
    func makeInitialChangeProfile() -> ChangeProfileView
    func makeInitialChangePhoneNumber() -> InitialChangePhoneNumberView
    func makeVerifyPhoneNumber() -> VerifyPhoneNumberView
    func makeInitialSettingAccount() -> InitialSetAccountView
    func makeInitialChangeEmail(email: String) -> ChangeEmailAccountView
    func makeVerifyChangeEmailAccount(newEmail: String, oldEmail: String) -> VerifyChangeEmailView
}
