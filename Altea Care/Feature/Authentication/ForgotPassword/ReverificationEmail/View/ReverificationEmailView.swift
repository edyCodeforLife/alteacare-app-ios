//
//  ReverificationEmailView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation

protocol ReverificationEmailView : BaseView {
    var viewModel : ReverificationEmailVM! {
        get set
    }
    
    var onReverificationEmailSuccedd : (() -> Void)? {
        get set
    }
    
    var email : String! { get set }
}
