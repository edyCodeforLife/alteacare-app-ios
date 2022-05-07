//
//  ChangeEmailAddressView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation

protocol ChangeEmailAddressView : BaseView {
    var viewModel : ChangeEmailAddressVM! { get set}
    var state : VerificationType! { get set}
    var onChangeEmailAddressSuccedd : (() -> Void)? { get set }
}
