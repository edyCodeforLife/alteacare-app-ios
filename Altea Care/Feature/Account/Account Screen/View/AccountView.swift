//
//  AccountView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol AccountView: BaseView {
    var viewModel: AccountVM! { get set }
    var goToChangeProfile : (() -> Void)? { get set }
    var goToSettingAccount : (() -> Void)? { get set }
    var goToFAQ : (() -> Void)? { get set }
    var goToContactUs : (() -> Void)? { get set }
    var goToTermCondition : (() -> Void)? { get set }
    var goToListFamilyMember : (() -> Void)? { get set }
    var signOutTapped :  (() -> Void)? { get set }
    var goToRegister : (() -> Void)? { get set }
    var goToLoginIn: (() -> Void)? { get set }
}
