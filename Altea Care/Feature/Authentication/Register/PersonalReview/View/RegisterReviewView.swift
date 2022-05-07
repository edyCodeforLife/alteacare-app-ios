//
//  RegisterReviewView.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation

protocol RegisterReviewView: BaseView {
    var viewModelRegisterReview : RegisterReviewVM! {
        get set
    }
    
    var goToContactField :  (() -> Void)? {
        get set
    }
    
    var goToChangeAddressEmail :  (() -> Void)? {
        get set
    }
}
