//
//  ContactUsView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

protocol ContactUsView : BaseView {
    var viewModel : ContactUsVM! { get set }
    var onSendButtonTapped : (() -> Void)? { get set }
}
