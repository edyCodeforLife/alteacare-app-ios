//
//  ContactFieldView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation

protocol ContactFieldView : BaseView {
    var isRoot : Bool! { get set }
    var viewModel : ContactFieldVM! {
        get set
    }
    
    var onContactFilledSucced : (() -> Void)? {
        get set
    }
    
    var onCloseFromSwitchAcc: (() -> Void)? { get set }
}
