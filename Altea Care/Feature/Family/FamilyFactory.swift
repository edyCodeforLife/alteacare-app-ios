//
//  FamilyFactory.swift
//  Altea Care
//
//  Created by Hedy on 10/08/21.
//

import Foundation

protocol FamilyFactory {
    func makeListMember() -> ListMemberView
    func makeAddMember() -> AddMemberView
    func makeEditMember() -> EditMemberView
    func makeVerifyMember() -> VerifyMemberView
    func makeRegisterMember() -> RegisterMemberView
    func makePasswordMember() -> PasswordMemberView
    func makeDetailMember() -> DetailMemberView
    func makeListAddress() -> ListAddressView
    func makeAddAddress() -> AddAddressView
    func makeEditAddress() -> EditAddressView
}
