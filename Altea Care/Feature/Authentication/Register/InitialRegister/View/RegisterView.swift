//
//  RegisterView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 12/03/21.
//

import Foundation

protocol RegisterView : BaseView {
    var onGenderPickerTapped: (() -> Void)? { get set }
    var viewModelRegister : RegisterVM! {
        get set
    }
    
    var goToNextRegisterStep: (() -> Void)? {
        get set
    }
}
