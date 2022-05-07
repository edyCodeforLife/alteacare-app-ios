//
//  InitialChangePhoneNumberView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

protocol InitialChangePhoneNumberView : BaseView {
    var viewModel : InitialChangePhoneNumberVM! { get set }
    var onVerifyTapped : ((String, String) -> Void)? { get set }
    var oldPhoneNumber : String! { get set }
}
