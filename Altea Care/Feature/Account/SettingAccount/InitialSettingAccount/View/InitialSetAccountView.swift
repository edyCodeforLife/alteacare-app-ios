//
//  InitialSetAccountView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 05/04/21.
//

import Foundation

protocol InitialSetAccountView : BaseView {
    var viewModel : InitialSetAccountVM! { get set }
    var goToChangePassword : (() -> Void)? { get set }
}
