//
//  ChangeProfileView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation

protocol ChangeProfileView : BaseView {
    var viewModel : InitialChangeProfileVM! { get set }
    var onChangePhoneNumberTapped: ((String) -> Void)? { get set }
    var onChangeEmailAddressTapped:  ((String) -> Void)? { get set }
    var onChangeDataPersonalTapped: (() -> Void)? { get set }
    var onChangeProfilePictureTapped: (() -> Void)? { get set }
    var onChangeAddressTapped: (() -> Void)? {get set}
}
