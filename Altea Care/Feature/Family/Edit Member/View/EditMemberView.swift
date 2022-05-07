//
//  EditMemberView.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation

protocol EditMemberView: BaseView {
    var chooseAddressTapped: (() -> Void)? { get set }
    var submitTapped: (() -> Void)? { get set }
    var viewModel: EditMemberVM! { get set }
    var detailMember : DetailMemberModel! {get set}
    var id : String! {get set}
    var selectedAddress: String? { get set }
    var selectedAddressID: String? { get set }
}
