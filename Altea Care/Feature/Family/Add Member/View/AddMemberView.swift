//
//  AddMemberView.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

protocol AddMemberView: BaseView {
    var addProfileTapped: (() -> Void)? { get set }
    var registMemberTapped: ((AddMemberBody) -> Void)? { get set }
    var chooseAddressTapped: (() -> Void)? { get set }
    var viewModel: AddMemberVM! { get set }
    var selectedAddressID: String? { get set }
    var selectedAddress: String? { get set }
    var isRoot: Bool! { get set }
}
