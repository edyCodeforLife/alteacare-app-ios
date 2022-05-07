//
//  EditAddressView.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

protocol EditAddressView: BaseView {
    var viewModel: EditAddressVM! { get set }
    var onSuccessEditAddress: (() -> Void)? { get set }
    var idAddress : String! { get set }
    var modelAddress : DetailAddressModel! { get set }
}
