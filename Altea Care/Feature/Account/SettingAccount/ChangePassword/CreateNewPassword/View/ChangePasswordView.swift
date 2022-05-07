//
//  ChangePasswordView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation

protocol ChangePasswordView: BaseView {
    var viewModel : ChangePasswordVM! { get set }
    var onChangePasswordSuccedd : (() -> Void)? { get set }
}
