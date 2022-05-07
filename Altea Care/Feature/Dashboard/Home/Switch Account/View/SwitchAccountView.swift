//
//  SwitchAccountView.swift
//  Altea Care
//
//  Created by Tiara on 09/09/21.
//

import Foundation
protocol SwitchAccountView: BaseView {
    var viewModel: SwitchAccountVM! { get set }
    var onGoToRegister: (() -> Void)? { get set }
    var onSignInTapped: (() -> Void)? { get set }
    var goToHome : (() -> Void)? { get set }
    var dataListAccount : (([UserCredential]))! { get set }
}
