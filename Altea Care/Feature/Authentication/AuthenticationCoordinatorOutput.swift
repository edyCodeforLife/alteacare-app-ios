//
//  AuthenticationCoordinatorOutput.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol AuthenticationCoordinatorOutput {
    var onMenubarFlow: (() -> Void)? { get set }
    var onMenuBarFlowCallCenter: ((Int) -> Void)? { get set }
    var onCloseFromSwitchAcc:(() -> Void)?{ get set}
}
