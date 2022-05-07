//
//  ChangeEmailAccountView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 27/07/21.
//

import Foundation

protocol ChangeEmailAccountView : BaseView {
    var viewModel : ChangeEmailVM! { get set }
    var onVerificationTapped : ((_ newEmail: String, _ oldEmail: String) -> Void)? { get set }
    var email : String? { get set }

}
