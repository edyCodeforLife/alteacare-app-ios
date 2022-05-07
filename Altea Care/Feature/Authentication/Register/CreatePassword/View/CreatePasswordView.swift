//
//  CreatePasswordView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation

protocol CreatePasswordView : BaseView {
    var viewModel : CreatePasswordVM! {
        get set
    }
    
    var onCreatePasswordSucceed : (() -> Void)? {
        get set
    }
}
