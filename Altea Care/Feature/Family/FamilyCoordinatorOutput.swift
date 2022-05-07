//
//  FamilyCoordinatorOutput.swift
//  Altea Care
//
//  Created by Hedy on 10/08/21.
//

import Foundation

protocol FamilyCoordinatorOutput {
    var onSelectedMember: ((MemberModel) -> Void)? { get set }
    var onCreatedMember: (() -> Void)? { get set }
}
