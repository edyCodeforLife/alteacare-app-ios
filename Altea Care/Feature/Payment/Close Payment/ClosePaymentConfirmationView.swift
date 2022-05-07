//
//  ClosePaymentConfirmationView.swift
//  Altea Care
//
//  Created by Ridwan Abdurrasyid on 22/02/22.
//

import Foundation

protocol ClosePaymentConfirmationView : BaseView {
    var onApproveTapped  : (() -> Void)? {get set}
}
