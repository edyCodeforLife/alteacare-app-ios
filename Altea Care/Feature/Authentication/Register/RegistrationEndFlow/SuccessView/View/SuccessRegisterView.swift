//
//  RegisterSuccessView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 28/04/21.
//

import Foundation

protocol SuccessRegisterView : BaseView {
    var viewModel : SuccessRegisterVM! { get set }
    var goToLogin : (() -> Void)? { get set }
}
