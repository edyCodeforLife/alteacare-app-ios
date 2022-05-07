//
//  FamilyFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 10/08/21.
//

import Foundation

extension ModuleFactoryImpl: FamilyFactory {
   
    func makeListMember() -> ListMemberView {
        let vc = ListMemberVC()
        vc.viewModel = makeListMemberVM()
        return vc
    }
    
    func makeAddMember() -> AddMemberView {
        let vc = AddMemberVC()
        vc.viewModel = makeAddMemberVM()
        return vc
    }
    
    func makeEditMember() -> EditMemberView {
        let vc = EditMemberVC()
        vc.viewModel = makeEditMemberVM()
        return vc
    }
    
    func makeVerifyMember() -> VerifyMemberView {
        let vc = VerifyMemberVC()
        vc.viewModel = makeVerifyMemberVM()
        return vc
    }
    
    func makeRegisterMember() -> RegisterMemberView {
        let vc = RegisterMemberVC()
        vc.viewModel = makeRegisterMemberVM()
        return vc
    }
    
    func makePasswordMember() -> PasswordMemberView {
        let vc = PasswordMemberVC()
        vc.viewModel = makePasswordMemberVM()
        return vc
    }
    
    func makeDetailMember() -> DetailMemberView {
        let vc = DetailMemberVC()
        vc.viewModel = makeDetailMemberVM()
        return vc
    }
    
    func makeListAddress() -> ListAddressView {
        let vc = ListAddressVC()
        vc.viewModel = makeListAddressVM()
        return vc
    }
    
    func makeAddAddress() -> AddAddressView {
        let vc = AddAddressVC()
        vc.viewModel = makeAddAddressVM()
        return vc
    }
    
    func makeEditAddress() -> EditAddressView {
        let vc = EditAddressVC()
        vc.viewModel = makeEditAddressVM()
        return vc
    }
    
}
