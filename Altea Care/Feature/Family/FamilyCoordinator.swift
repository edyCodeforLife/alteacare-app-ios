//
//  FamilyCoordinator.swift
//  Altea Care
//
//  Created by Hedy on 10/08/21.
//

import Foundation

class FamilyCoordinator: BaseCoordinator, FamilyCoordinatorOutput {
    var onSelectedMember: ((MemberModel) -> Void)?
    var onCreatedMember: (() -> Void)?
    
    private let router: Router
    private let factory: FamilyFactory
    private lazy var addMemberview = factory.makeAddMember()
    private lazy var editMemberview = factory.makeEditMember()
    
    init(router: Router, factory: FamilyFactory) {
        self.router = router
        self.factory = factory
    }
    
    override func start(family with: FamilyModeEntry) {
        switch with {
        case .readFamily:
            showListMember(isReadOnly: true)
        case .listFamily:
            showListMember()
        case .setPassword:
            showListMember(isDirectToSetPassword: true)
        case .addMember:
            showAddMember(isRoot: true)
        case .listAddress:
            showListAddress(isFrom: .editProfile, isRoot: true)
        }
    }
    
    private func showListMember(isDirectToSetPassword: Bool = false, isReadOnly: Bool = false) {
        let view = factory.makeListMember()
        view.isReadOnly = isReadOnly
        
        view.onCreateNewFamilyMember = { [weak self] in
            guard let self = self else { return }
            self.showAddMember(isRoot: false)
        }
        
        view.onDetailMember = { [weak self] (patient)in
            guard let self = self else { return }
            if isReadOnly {
                self.onSelectedMember?(patient)
            } else {
                self.showDetailMember(id: patient.idMember)
            }
        }
        
        if isDirectToSetPassword {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showPasswordMember()
            }
        }
        router.setRootModule(view)
    }
    
    private func showAddMember(isRoot: Bool) {
        addMemberview = factory.makeAddMember()
        addMemberview.isRoot = isRoot
        addMemberview.registMemberTapped = { [weak self] (data) in
            guard let self = self else { return }
            self.showRegisterMember(data: data)
        }
        
        addMemberview.chooseAddressTapped = { [weak self] in
            guard let self = self else { return }
            self.showListAddress(isFrom: .addFamily)
        }
        
        addMemberview.addProfileTapped = { [weak self] in
            guard let self = self else { return }
            self.router.popModule()
        }
        if isRoot == true {
            router.setRootModule(addMemberview)
        }else {
            router.push(addMemberview)
        }
    }
    
    private func showEditMember(id: String) {
        editMemberview.id = id
        editMemberview.submitTapped = { [weak self] in
            guard let self = self else { return }
            self.router.popModule()
        }
        
        editMemberview.chooseAddressTapped = { [weak self] in
            guard let self = self else { return }
            self.showListAddress(isFrom: .editFamily)
        }
        
        router.push(editMemberview)
    }
    
    private func showVerifyMember() {
        let view = factory.makeVerifyMember()
        router.push(view)
    }
    
    private func showRegisterMember(data: AddMemberBody) {
        let view = factory.makeRegisterMember()
        view.isFromDetail = false
        view.patientData = data
        view.resgistTapped = { [weak self] in
            guard let self = self else { return }
            self.router.popToRootModule(animated: true)
        }
        router.push(view)
    }
    
    private func showRegisterMemberFromDetail(id: String) {
        let view = factory.makeRegisterMember()
        view.isFromDetail = true
        view.id = id
        view.resgistTapped = { [weak self] in
            guard let self = self else { return }
            self.router.popToRootModule(animated: true)
        }
        router.push(view)
    }
    
    private func showPasswordMember() {
        let view = factory.makePasswordMember()
        router.push(view)
    }
    
    private func showDetailMember(id : String) {
        let view = factory.makeDetailMember()
        view.idPatient = id
        view.onChangeUserData = { [weak self] (idPatient)in
            guard let self = self else { return }
            self.showEditMember(id: idPatient)
        }
        
        view.onRegisterdAsAccount = { [weak self] (idPatient) in
            guard let self = self else { return }
            self.showRegisterMemberFromDetail(id: idPatient)
        }
        view.onDeleteMember = { [weak self] in
            guard let self = self else { return }
            self.router.popModule()
        }
        router.push(view)
    }
    
    private func showListAddress(isFrom: AddressModeEntry, isRoot: Bool = false) {
        let view = factory.makeListAddress()
        view.isRoot = true
        view.onAddNewAddres = { [weak self] in
            guard let self = self else { return }
            self.showAddAddress()
        }
        view.onEditAddress = { [weak self] (dataAddress, idAddress) in
            guard let self = self else { return }
            self.showEditAddress(data: dataAddress, idAddress: idAddress)
        }
        //Send Address when tapped at table view cell address
        view.onSendStringAddress = { [weak self] (IdAddress, ComplitAddress) in
            guard let self = self else { return }
            switch isFrom{
            case .addFamily:
                self.addMemberview.selectedAddressID = IdAddress
                self.addMemberview.selectedAddress = ComplitAddress
            case .editFamily:
                self.editMemberview.selectedAddressID = IdAddress
                self.editMemberview.selectedAddress = ComplitAddress
            case .editAddress:
                break
            case .editProfile:
                break
            }
            self.router.popModule(animated: true)
        }
        
        if isRoot {
            router.setRootModule(view)
        } else {
            router.push(view)
        }
    }
    
    private func showAddAddress() {
        let view = factory.makeAddAddress()
        view.onSuccessAddAddress = { [weak self] in
            guard let self = self else { return }
            self.router.popModule(animated: true)
        }
        router.push(view)
    }
    
    private func showEditAddress(data : DetailAddressModel, idAddress : String) {
        let view = factory.makeEditAddress()
        view.modelAddress = data
        view.idAddress = idAddress
        view.onSuccessEditAddress = { [weak self] in
            guard let self = self else { return }
            self.showListAddress(isFrom: .editAddress)
        }
        router.push(view)
    }
    
}
