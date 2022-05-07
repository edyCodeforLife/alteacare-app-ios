//
//  CreateNewPasswordView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation

protocol CreateNewPasswordView : BaseView {
    
    var viewModel : CreateNewPasswordVM! { get set }
    var onCreatePasswordSuccedd : (() -> Void)? { get set}
}
