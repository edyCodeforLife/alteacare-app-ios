//
//  AccountCoordinatorOutput.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol AccountCoordinatorOutput {
    var onAuthFlow: (() -> Void)? { get set }
    var onLogout: (() -> Void)? { get set }
    var onFamilyMemberFlow: (() -> Void)? { get set }
    var onAuthFlowWithEntry: ((AuthEntry) -> Void)? { get set }
}
