//
//  AddAddressView.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

protocol AddAddressView: BaseView {
    var viewModel: AddAddressVM! { get set }
    var onSuccessAddAddress: (() -> Void)? { get set }
}
