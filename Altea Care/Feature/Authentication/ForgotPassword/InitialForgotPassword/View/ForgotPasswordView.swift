//
//  ForgotPasswordView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation

protocol ForgotPasswordView : BaseView {
    var viewModel : ForgotPasswordVM! {
        get set
    }
    
    var onForgotPasswordSuccedd: ((String) -> Void)? {
        get set
    }
}
