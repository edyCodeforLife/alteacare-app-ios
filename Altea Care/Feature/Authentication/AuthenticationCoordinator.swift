//
//  AuthenticationCoordinator.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

class AuthenticationCoordinator: BaseCoordinator, AuthenticationCoordinatorOutput {
    
    var onCloseFromSwitchAcc: (() -> Void)?
    var onMenubarFlow: (() -> Void)?
    var onMenuBarFlowCallCenter: ((Int) -> Void)?
    
    private let router: Router
    private let factory: AuthenticationFactory
    
    init(router: Router, factory: AuthenticationFactory) {
        self.router = router
        self.factory = factory
    }
    
    override func start(auth with: AuthEntry) {
        switch with {
        case .login(let photoDoctor, let doctorName):
            self.showLogin(photoDoctor: photoDoctor, doctorName: doctorName)
        case.register:
            self.showRegisterContactField(isRoot: true)
        case .forgotPassword:
            self.showInitialForgotPassword()
        case .callCenter:
            self.showContactUs()
        }
    }
    
    override func start() {
        showLogin()
    }
    
    private func showLogin(photoDoctor: String? = nil, doctorName: String? = nil) {
        let view = factory.makeLoginView()
        view.photoDoctor = photoDoctor
        view.doctor = doctorName
        view.onLoginSucceed = { [weak self] in
            guard let self = self else { return }
            self.onMenubarFlow?()
        }
        view.onDaftarTapped = { [weak self] in
            guard let self = self else { return }
            self.showRegisterContactField(isRoot: false)
        }
        view.forgotKataSandi = { [weak self] in
            guard let self = self else { return }
            self.showInitialForgotPassword()
        }
        view.needHelpTapped = { [weak self] in
            guard let self = self else { return }
            self.showContactUs()
        }
        view.onVerifiedAccount = { [weak self] type in
            guard let self = self else { return }
            self.showEmailVerification(type: type, isFromLogin: true)
        }
        
        if doctorName != nil {
            router.push(view, animated: true, hideBar: false, hideBottomBar: true, completion: nil)
        } else {
            router.setRootModule(view, hideBar: true, animation: .bottomUp)
        }
    }
    
    func showContactUs(){
        let view = factory.makeContactUsView()
        view.onSendButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.showLogin()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    func showRegister() {
        let view = factory.makeRegisterView()
        view.goToNextRegisterStep = { [weak self ] in
            guard let self = self else { return }
            self.showRegisterReview()
        }

        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    func showRegisterReview(){
        let view = factory.makeRegisterReviewView()
        view.goToContactField = { [weak self ] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.showCreatePassword()
            }
        }
        view.goToChangeAddressEmail = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule()
        }
        router.present(view, animated: true, mode: .basic, isWrapNavigation: true)
    }
    
    func showRegisterContactField(isRoot: Bool) {
        let view = factory.makeContactFieldView()
        view.isRoot = isRoot
        view.onContactFilledSucced = { [weak self ] in
            guard let self = self else { return }
            self.showRegister()
        }
        
        view.onCloseFromSwitchAcc = { [weak self] in
            guard let self = self else { return }
            self.onCloseFromSwitchAcc?()
        }
        
        if isRoot {
            router.setRootModule(view, hideBar: false, animation: .bottomUp)
        }else{
            router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
        }
    }
    
    func showCreatePassword(){
        let view = factory.makeCreatePasswordView()
        view.onCreatePasswordSucceed = { [weak self ] in
            guard let self = self else { return }
            self.showTermAndConditionCheck()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    func showTermAndConditionCheck(){
        let view = factory.makeTermAndConditionView()
        view.onButtonSubmitTapped = { [weak self ] in
            guard let self = self else { return }
            self.showEmailVerification(type: .phone, isFromLogin: false)
        }
        router.push(view, animated: true, completion: nil)
    }
    
    func showChangeEmailAddress(type: VerificationType){
        let view = factory.makeChangeEmailAddressView()
        view.state = type
        view.onChangeEmailAddressSuccedd = { [weak self ] in
            guard let self = self else { return }
            self.showEmailVerification(type: type, isFromLogin: false)
        }
        router.push(view, animated: true, completion: nil)
    }
    
    func showEmailVerification(type: VerificationType, isFromLogin: Bool){
        let view = factory.makeEmailVerification()
        view.state = type
        view.isFromLogin = isFromLogin
        view.onEmailVerificationSuccedd = { [weak self ] in
            guard let self = self else { return }
            self.showRegisterSucced()
        }
        view.onChangeEmailAddress = { [weak self] state in
            guard let self = self else { return }
            self.showChangeEmailAddress(type: state)
        }
        router.push(view, animated: true, completion: nil)
    }
    
    func showRegisterSucced(){
        let view = factory.makeRegisterSuccedView()
        view.goToLogin = { [weak self ] in
            guard let self = self else { return }
            self.showLogin()
        }
        router.push(view, animated: true, completion: nil)
    }
    
    func showCreateNewPassword(){
        let view = factory.makeCreateNewPasswordView()
        view.onCreatePasswordSuccedd = { [weak self ] in
            guard let self = self else { return }
            self.router.dismissModule()
            self.showLogin()
        }
        router.push(view, animated: true, completion: nil)
    }
    
    func showReverificationEmail(email : String){
        let view = factory.makeReverificationEmailView()
        view.email = email
        view.onReverificationEmailSuccedd = { [weak self ] in
            guard let self = self else { return }
            self.showCreateNewPassword()
        }
        router.push(view, animated: true, completion: nil)
    }
    
    func showInitialForgotPassword(){
        let view = factory.makeForgotPasswordView()
        view.onForgotPasswordSuccedd = { [weak self ] (email) in
            guard let self = self else { return }
            self.showReverificationEmail(email: email)
        }
        router.push(view, animated: true, completion: nil)
    }
    
}
