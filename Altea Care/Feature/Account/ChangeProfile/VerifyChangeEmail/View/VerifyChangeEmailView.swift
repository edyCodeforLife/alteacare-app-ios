//
//  VerifyChangeEmailView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation

protocol VerifyChangeEmailView: BaseView {
    var viewModel : VerifyChangeEmailVM! { get set }
    var changeEmailVM : ChangeEmailVM! {get set}
    var onVerifySuccedd: (() -> Void)? { get set }
    var newEmail: String? {get set}
    var oldEmail: String? {get set}

}
