//
//  ChangePersonalDataView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

protocol ChangePersonalDataView : BaseView {
    var viewModel : ChangePersonalDataVM! { get set }
    var onButtonCallTapped : (() -> Void)? { get set }
}
