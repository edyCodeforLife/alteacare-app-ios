//
//  DashboardCoordinator.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

class DashboardCoordinator: BaseCoordinator, DashboardCoordinatorOutput {
    var goToDoctorSpecialist: (() -> Void)?
    var onEndConsultations: (() -> Void)?
    var onEndConsultation: (() -> Void)?
    var goToMyConsultation: (() -> Void)?
    var goToCancelledConsultation: (() -> Void)?
    var goToCompleteConsults: (() -> Void)?
    var onAuthFlow: (() -> Void)?
    var onAuthFlowWithEntry: ((AuthEntry) -> Void)?
    
    private let router: Router
    private let factory: DashboardFactory
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, factory: DashboardFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start(with: DeepLinkOption?, indexTab: SelectedTabEntry?=nil) {
        guard let option = with else{
            showDashboard()
            return
        }
        showDashboard(){
            switch option{
            case .appointmentPaymentSuccess(let id):
                self.runPaymentFlow(entry: .paymentReview(id: id))
            case .appointmentCompleted(_):
                self.goToCompleteConsults?()
            case .appointmentWaitingForPayment(let id):
                self.runPaymentFlow(entry: .waitingForPayment(id: id))
            case .appointmentCancelledByGP(let id), .appointmentCancelledBySystem(let id):
                self.runDetailConsultationFlow(entry: .cancelledBooking(id))
            case .appointmentScheduleChanged(_), .appointmentSpecialistChanged(_):
                self.goToMyConsultation?()
            case .appointment15BeforeMeet(_), .appointmentMeetSpecialist(_):
                self.goToMyConsultation?()
            case .appointmentPaymentRefunded(let id):
                self.runDetailConsultationFlow(entry: .cancelledBooking(id))
            case .appointment15AfterOngoing(_):
                self.goToMyConsultation?()
            case .appointment15ToEndMeet(_):
                self.goToMyConsultation?()
            }
        }
    }
    
    private func showDashboard(_ completion: (() -> ())? = nil) {
        let view = factory.makeHomeView()
        view.onTappedListDoctorSpecialization = { [weak self] (id, name, iSearch) in
            guard let self = self else { return }
            self.runBookingFlow(entry: .listDoctorSpecialization(idSpecialist: id, nameSpecialist: name, isSearch: false, inputSearch: "", isRoot: true))
        }
        
        view.onSignInTapped = { [weak self] in
            guard let self = self else { return }
            self.onAuthFlow?()
        }
        view.onGotoWebView = { [weak self] (url, isNeedLogin) in
            guard let self = self else { return }
            self.showWebView(url: url, isNeedLogin: isNeedLogin)
        }
        
        view.onConsultationCallingTapped = { [weak self] (id, orderCode, isMA) in
            guard let self = self else { return }
            self.runScreeningConsultationFlow(id: id, orderCode: orderCode, callMA: isMA)
        }
        
        view.onConsultationTapped = { [weak self] (id, status) in
            guard let self = self else { return }
            self.runDetailConsultationFlow(entry: .detailConsultation(Int(id) ?? 0, status))
        }
        
        view.onPaymentMethodTapped = {[weak self] id in
            guard let self = self else { return }
            self.runPaymentFlow(entry: .basic(id: id))
        }
        
        view.onPaymentContinueTapped = {[weak self] (url, id) in
            guard let self = self else { return }
            self.showWebViewpayment(paymentUrl: url, appointmentId: id)
        }
        
        view.onSearchAutocomplete = { [weak self]  in
            guard let self = self else { return }
            self.runBookingFlow(entry: .searchAutocomplete)
        }
        
        view.onGoToRegister = { [weak self] in
            guard let self = self else { return }
            //Need help to change to register view
            self.onAuthFlowWithEntry?(.register)
        }
        
        view.onChangeAccount = { [weak self] (data) in
            guard let self = self else { return }
            self.showSwitchAccount(data: data)
        }
        view.onGoToForceUpdate = { [weak self] in
            guard let self = self else { return }
            self.showForceUpdate()
        }
        
        view.onOutsideOperatingHour = { [weak self] setting in
            guard let self = self else { return }
            self.showOutsideOperatingHour(setting: setting) {
                
            }
        }
        
        view.onGoToDoctorSpecialist = { [weak self] in
            guard let self = self else { return }
            self.goToDoctorSpecialist?()
        }
        
        router.setRootModule(view, hideBar: false, animation: .bottomUp)
        completion?()
    }
    
    func showForceUpdate(){
        let view = factory.makeForceUpdateView()
        view.goToAppStore = { [weak self] in
            guard let self = self else { return }
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
    
    private func showWebView(url: String, isNeedLogin: Bool) {
        let view = factory.makeWebView()
        view.url = url
        view.isNeedLogin = isNeedLogin
        view.goHome = { [weak self] in
            guard let self = self else { return }
            self.showDashboard()
        }
        router.push(view, animated: true, hideBar: true, hideBottomBar: true, completion: nil)
    }
        
    private func runBookingFlow(entry: BookingModeEntry) {
        var (coordinator, module) = coordinatorFactory.makeBookingCoordinator()
        coordinator.onEndBooking = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                self.router.popModule()
                self.removeDependency(coordinator)
            }
        }
        
        coordinator.gotoMyConsultation = {
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                self.removeDependency(coordinator)
                self.goToMyConsultation?()
            }
        }
        addDependency(coordinator)
        router.present(module)
        coordinator.start(booking: entry)
    }
    
    private func runScreeningConsultationFlow(id: Int, orderCode: String?, callMA: Bool) {
        var (coordinator, module) = coordinatorFactory.makeConsultationCoordinator()
        coordinator.onEndConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "onEndBooking"), object: nil)
                    self.removeDependency(coordinator)
                }
            }
        }
        
        coordinator.onCancelConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "onCancelConsultation"), object: nil)
                    self.removeDependency(coordinator)
                }
            }
        }
        
        coordinator.onCloseConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
            }
        }
        
        coordinator.onGoDashboard = { [weak self] in
            guard let self = self else { return }
            self.showDashboard()
        }
        addDependency(coordinator)
        router.present(module)
        coordinator.start(consultation: .reconsultation(id, orderCode, callMA))
    }

    func showSwitchAccount(data : [UserCredential]){
        let view = factory.makeSwitchAccountView()
        view.dataListAccount = data
        view.onGoToRegister = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.onAuthFlowWithEntry?(.register)
            }
        }
        
        view.onSignInTapped = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.onAuthFlow?()
            }
        }
        
        view.goToHome = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.showDashboard()
            }
        }
        router.present(view, animated: true, mode: .basic, isWrapNavigation: true)
    }
    
    private func showOutsideOperatingHour(setting: SettingModel, gotoMyConsultation: @escaping ()->Void){
        let view = factory.makeOutsideOperatingHourViewFromDashboard(setting: setting)
        
        view.onOkPressed = {
            self.router.dismissPanModal()
            self.router.popToRootModule(animated: false)
            self.goToMyConsultation?()
        }
        router.pushPanModal(view)
    }
    
    private func showWebViewpayment(paymentUrl : String, appointmentId : Int){
        let view = factory.makeWebViewPayment()
        view.paymentUrl = paymentUrl
        view.appointmentId = appointmentId
        view.checkStatusPaymentTappedPayed = { [weak self] (appointmentId) in
            guard let self = self else { return }
            self.showReviewPayment(appintmentId: appointmentId)
        }
        view.onBackTapped = { [weak self]  in
            guard let self = self else { return }
            self.showConfirmationView()
        }
        router.push(view, animated: true, completion: nil)
    }
    
    private func showReviewPayment(appintmentId : Int) {
        let view = factory.makeReviewPayment()
        view.appointmentId = appintmentId
        view.onPaymentReviewed = { [weak self] in
            guard let self = self else { return }
            self.onEndConsultation?()
        }
        view.goDashboard = { [weak self] in
            guard let self = self else { return }
        }
        router.push(view, animated: true, hideBar: false, hideBottomBar: true, completion: nil)
    }
    
    private func showConfirmationView() {
        let view = factory.makeCloseConfirmationView()
        view.onApproveTapped = { [weak self] in
            guard let self = self else { return }
            self.router.popModule()
        }
        router.pushPanModal(view)
    }
    
    func runPaymentFlow(entry: PaymentModeEntry) {
        var (coordinator, module) = coordinatorFactory.makePaymentCoordinator()
        coordinator.onPaymentReviewed = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
                self.goToMyConsultation?()
            }
        }
        
        coordinator.onGoDashboard = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
            }
        }
        coordinator.onPaymentCanceled = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
            }
        }
        
        addDependency(coordinator)
        router.present(module)
        coordinator.start(payment: entry)
    }
    
    func runDetailConsultationFlow(entry: ConsultationModeEntry) {
        var (coordinator, module) = coordinatorFactory.makeConsultationCoordinator()
        coordinator.onEndConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
            }
        }
        
        coordinator.onGoDashboard = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                self.router.popModule()
                self.removeDependency(coordinator)
            }
        }
        
        addDependency(coordinator)
        router.present(module)
        coordinator.start(consultation: entry)
    }
}
