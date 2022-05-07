//
//  AccountCoordinator.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

class AccountCoordinator: BaseCoordinator, AccountCoordinatorOutput {
    
    var onLogout: (() -> Void)?
    var onFamilyMemberFlow: (() -> Void)?
    var onAuthFlow: (() -> Void)?
    var onAuthFlowWithEntry: ((AuthEntry) -> Void)?
    private let router: Router
    private let factory: AccountFactory
    
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, factory: AccountFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        showAccount()
    }
    
    private func showAccount() {
        let view = factory.makeAccount()
        view.goToSettingAccount = { [weak self] in
            guard let self = self else { return }
            self.showInitialSetAccount()
        }
        view.goToChangeProfile = { [weak self] in
            guard let self = self else { return }
            self.showChangeProfile()
        }
        view.goToFAQ = { [weak self] in
            guard let self = self else { return }
            self.showFaq()
        }
        view.goToContactUs = { [weak self] in
            guard let self = self else { return }
            self.showContactUs()
        }
        view.goToTermCondition = { [weak self] in
            guard let self = self else { return }
            self.showTermCondition()
        }
        view.signOutTapped = { [weak self] in
            guard let self = self else { return }
            self.onLogout?()
        }
        view.goToListFamilyMember = { [weak self] in
            guard let self = self else { return }
            self.runFamilyFlow()
        }
        //Need help to fix this, go to register view on auth flow
        view.goToRegister = { [weak self ] in
            guard let self = self else { return }
//            self.router.dismissModule()
            self.onAuthFlowWithEntry?(.register)
        }
        view.goToLoginIn = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule()
            self.onAuthFlow?()
        }
        router.setRootModule(view, hideBar: true)
    }
    
    private func runFamilyFlow() {
        let (coordinator, module) = coordinatorFactory.makeFamilyCoordinator()
        addDependency(coordinator)
        router.present(module)
        coordinator.start(family: .listFamily)
    }
    
    private func showChangeProfile() {
        let view = factory.makeInitialChangeProfile()
        view.onChangeDataPersonalTapped = { [weak self] in
            guard let self = self else { return }
            self.showChangePersonalData()
        }
        view.onChangeEmailAddressTapped = { [weak self] (email) in
            guard let self = self else { return }
            self.showInitialChangeEmailAccount(email: email)
        }
        view.onChangePhoneNumberTapped = { [weak self] (phoneNumberOld)in
            guard let self = self else { return }
            self.showInitialChangePhoneNumber(oldPhoneNumberString: phoneNumberOld)
        }
        view.onChangeAddressTapped = { [weak self] in
            guard let self = self else { return }
            self.showAddressList()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showInitialChangeEmailAccount(email: String){
        let view = factory.makeInitialChangeEmail(email: email)
        view.onVerificationTapped = { (newEmail, oldEmail) in
            self.showVerifyChangeEmailAccount(newEmail: newEmail, oldEmail: oldEmail)
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showVerifyChangeEmailAccount(newEmail :String, oldEmail: String){
        let view = factory.makeVerifyChangeEmailAccount(newEmail: newEmail, oldEmail: oldEmail)
        view.onVerifySuccedd = { [weak self] in
            guard let self = self else { return }
            self.showAccount()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showVerifyPhoneNumber(phoneNumber : String, oldPhoneNumber : String){
        let view = factory.makeVerifyPhoneNumber()
        view.phoneNumber = phoneNumber
        view.oldPhoneNumber = oldPhoneNumber
        view.onChangePhoneNumber = { [weak self] in
            guard let self = self else { return }
            self.showInitialChangePhoneNumber(oldPhoneNumberString: oldPhoneNumber)
        }
        view.onVerifyPhoneNumberSuccedd = { [weak self] in
            guard let self = self else { return }
            self.showAccount()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showInitialSetAccount() {
        let view = factory.makeInitialSettingAccount()
        view.goToChangePassword = { [weak self] in
            guard let self = self else { return }
            self.showOldPassword()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showTermCondition(){
        let view = factory.makeTermCondition()
        view.onUnderstandTapped = { [weak self] in
            guard let self = self else { return }
            self.showAccount()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showChangePersonalData(){
        let view = factory.makeChangePersonalData()
        view.onButtonCallTapped =  { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule()
            self.showContactUs()
        }
        router.present(view, mode: .basic)
    }
    
    private func showContactUs() {
        let view = factory.makeContactUs()
        view.onSendButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.showAccount()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showFaq() {
        let view = factory.makeFaq()
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showOldPassword(){
        let view = factory.makeOldPassword()
        view.oldPasswordSucced = { [weak self] in
            guard let self = self else { return }
            self.showChangePassword()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showChangePassword(){
        let view = factory.makeChangePassword()
        view.onChangePasswordSuccedd = { [weak self] in
            guard let self = self else { return }
            self.showAccount()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showInitialChangePhoneNumber(oldPhoneNumberString: String){
        let view = factory.makeInitialChangePhoneNumber()
        view.oldPhoneNumber = oldPhoneNumberString
        view.onVerifyTapped = { [weak self] (phoneNumber, oldPhoneNumber) in
            guard let self = self else { return }
            self.showVerifyPhoneNumber(phoneNumber: phoneNumber, oldPhoneNumber: oldPhoneNumber)
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showAddressList() {
        let (coordinator, module) = coordinatorFactory.makeFamilyCoordinator()
        addDependency(coordinator)
        router.present(module)
        coordinator.start(family: .listAddress)
    }
}
