//
//  VerifyPhoneNumberView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

protocol VerifyPhoneNumberView : BaseView {
    var viewModel : VerifyPhoneNumberVM! { get set }
    var onVerifyPhoneNumberSuccedd : (() -> Void)? { get set}
    var onChangePhoneNumber : (() -> Void)? { get set }
    var phoneNumber : String! { get set }
    var oldPhoneNumber : String! { get set }
}
