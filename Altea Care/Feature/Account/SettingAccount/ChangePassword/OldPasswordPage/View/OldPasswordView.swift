//
//  OldPasswordView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 05/04/21.
//

import Foundation

protocol OldPasswordView : BaseView {
    var viewModel : OldPasswordVM! { get set }
    var oldPasswordSucced : (() -> Void)? { get set }
}
