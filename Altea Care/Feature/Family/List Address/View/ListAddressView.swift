//
//  ListAddressView.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

protocol ListAddressView: BaseView {
    var viewModel: ListAddressVM! { get set }
    var onAddNewAddres: (() -> Void)? { get set }
    var onEditAddress: ((_ DataAddress : DetailAddressModel, String) -> Void)? { get set }
    var onSendStringAddress: ((String, String) -> Void)? { get set }
    var addressFix: String! { get set }
    var isRoot: Bool! { get set }
}
