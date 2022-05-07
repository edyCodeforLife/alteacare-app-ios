//
//  MenubarCoordinator.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import UIKit

class MenubarCoordinator: BaseCoordinator, MenubarCoordinatorOutput,AccountCoordinatorOutput {
    var onAuthFlowWithEntry: ((AuthEntry) -> Void)?
    var onFamilyMemberFlow: (() -> Void)?
    
    var logout: (() -> Void)?
    var onLogout: (() -> Void)?
    var onAuthFlow: (() -> Void)?
    var goToContactAltea: (() -> Void)?
    var goDashboard: (() -> Void)?
    var goToPaymentFlow: ((PaymentModeEntry) -> Void)?
    var goToConsultationFlow: ((ConsultationModeEntry) -> Void)?
    var goToMyConsultations: (() -> Void)?
    var goToCancelledConsultation: (() -> Void)?
    var goToCompleteConsults: (() -> Void)?
    let tabbarView: TabbarView
    private let coordinatorFactory: CoordinatorFactory
    private var goToCancel: Bool?
    init(tabbarView: TabbarView, coordinatorFactory: CoordinatorFactory) {
        self.tabbarView = tabbarView
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start(){
        tabbarView.onViewDidLoad = runTheFirstFlow(entry: nil)
        tabbarView.onTheFirstSelected = runTheFirstFlow(entry: nil)
        tabbarView.onTheSecondSelected = runTheSecondFlow()
        tabbarView.onTheThirdSelected = runTheThirdFlow(entry: nil)
        tabbarView.onTheFourthSelected = runTheFourthFlow()
    }
    
    override func start(with option: DeepLinkOption?, indexTab selectTab: SelectedTabEntry?) {
        if let entry = option {
            switch entry {
            case .appointmentCompleted(_):
                tabbarView.onViewDidLoad = runTheFirstFlow(entry: nil)
                tabbarView.onTheFirstSelected = runTheFirstFlow(entry: nil)
                tabbarView.onTheSecondSelected = runTheSecondFlow()
                tabbarView.onTheThirdSelected = runTheThirdFlow(entry: option)
                tabbarView.onTheFourthSelected = runTheFourthFlow()
                tabbarView.goToByIndexTab = 2
            default:
                tabbarView.onViewDidLoad = runTheFirstFlow(entry: option)
                tabbarView.onTheFirstSelected = runTheFirstFlow(entry: option)
                tabbarView.onTheSecondSelected = runTheSecondFlow()
                tabbarView.onTheThirdSelected = runTheThirdFlow(entry: nil)
                tabbarView.onTheFourthSelected = runTheFourthFlow()
            }
        }else{
            start()
            switch selectTab {
            case .tabIndex(let index) :
                if index == 2 {
                    tabbarView.goToByIndexTab = 2
                }
            default: break
            }
        }
    }
    
    private func runTheFirstFlow(entry: DeepLinkOption?) -> ((UINavigationController) -> Void) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty {
                var (coordinator, _) = self.coordinatorFactory.makeDashboardCoordinator(navController: navController)
                
                NotificationCenter.default.addObserver(self, selector: #selector(onEndBooking), name: NSNotification.Name.init(rawValue: "onEndBooking"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(goToLogin), name: NSNotification.Name.init(rawValue: "goToLogin"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(onCancelConsultation), name: NSNotification.Name.init(rawValue: "onCancelConsultation"), object: nil)
                
                coordinator.onAuthFlow = {
                    self.onAuthFlow?()
                }
                
                coordinator.onAuthFlowWithEntry = { (entry) in
                    self.onAuthFlowWithEntry?(entry)
                }
                
                coordinator.onEndConsultations = {
                    
                }
                
                coordinator.goToMyConsultation = {
                    tabbarView.goToByIndexTab = 2
                }
                
                coordinator.goToDoctorSpecialist = {
                    tabbarView.goToByIndexTab = 1
                }
                
                coordinator.goToCancelledConsultation = {
                    tabbarView.goToByIndexTab = 2
                    self.goToCancelledConsultation?()
                }
                
                coordinator.goToCompleteConsults = {
                    tabbarView.goToByIndexTab = 2
                    self.goToCompleteConsults?()
                }
                
                self.addDependency(coordinator)
                coordinator.start(with: entry, indexTab: .tabIndex(5))
            }
        }
    }
    
    private func runTheSecondFlow() -> ((UINavigationController) -> Void) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty {
                var (coordinator, _) = self.coordinatorFactory.makeBookingCoordinator(navController: navController)
                
                NotificationCenter.default.addObserver(self, selector: #selector(onEndBooking), name: NSNotification.Name.init(rawValue: "onEndBooking"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(goToDashboard), name: NSNotification.Name.init(rawValue: "goToDashboard"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(goToLogin), name: NSNotification.Name.init(rawValue: "goToLogin"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(onCancelConsultation), name: NSNotification.Name.init(rawValue: "onCancelConsultation"), object: nil)
                
                coordinator.onEndBooking = {
                    tabbarView.goToByIndexTab = 2
                    
                }
                coordinator.goToDashboard = {
                    tabbarView.goToByIndexTab = 0
                    
                }
                coordinator.onEndConsultation = {
                    tabbarView.goToByIndexTab = 2
                    
                }
                coordinator.gotoMyConsultation = {
                    tabbarView.goToByIndexTab = 2
                    
                }
                coordinator.onAuthFlowWithEntry = { (entry) in
                    self.onAuthFlowWithEntry?(entry)
                }
                coordinator.onAuthFlow = {
                    self.onAuthFlow?()
                }
                
                self.addDependency(coordinator)
                coordinator.start()
            }
        }
    }
    
    @objc private func onCancelConsultation() {
        self.tabbarView.navigateTabInMyConsultation = 2
    }
    
    @objc private func onEndBooking() {
        self.tabbarView.navigateTabInMyConsultation = 0
    }
    
    @objc private func goToDashboard() {
        tabbarView.goToByIndexTab = 0
    }
    
    @objc private func goToLogin() {
        self.onAuthFlow?()
    }
    
    private func runTheThirdFlow(entry: DeepLinkOption?) -> ((UINavigationController, Int?) -> Void) {
        return { [unowned self] (navController, index) in
            let token = Preference.getString(forKey: .AccessTokenKey) ?? ""
            if token.isEmpty {
                self.onAuthFlow?()
            } else {
                if navController.viewControllers.isEmpty {
                    var (coordinator, _) = self.coordinatorFactory.makeConsultationCoordinator(navController: navController)
                    NotificationCenter.default.addObserver(self, selector: #selector(goToDashboard), name: NSNotification.Name.init(rawValue: "goToDashboard"), object: nil)
                    coordinator.onEndConsultation = {
                        tabbarView.goToByIndexTab = 2
                    }
                    coordinator.onGoDashboard = {
                        tabbarView.goToByIndexTab = 0
                    }
                    coordinator.onGoConsultation = {
                        
                    }
                    self.addDependency(coordinator)
                    
                    if let entry = entry {
                        switch entry {
                        case .appointmentPaymentRefunded(_):
                            coordinator.start(consultation: .cancelledList)
                        case .appointmentCompleted(_):
                            coordinator.start(consultation: .doneList)
                        default: coordinator.start(consultation: .listConsultation(index))
                        }
                    } else {
                        coordinator.start(consultation: .listConsultation(index))
                    }
                    
                } else {
                    if let target = navController.viewControllers.first as? ListConsultationVC {
                        target.goToIndex = index
                    }
                }
            }
        }
    }
    
    private func runTheFourthFlow() -> ((UINavigationController) -> Void) {
        return { [unowned self] navController in
            let token = Preference.getString(forKey: .AccessTokenKey) ?? ""
            
            if token.isEmpty{
                self.onAuthFlow?()
            } else {
                if navController.viewControllers.isEmpty {
                    var (coordinator, _) = self.coordinatorFactory.makeAccountCoordinator(navController: navController)
                    coordinator.onLogout = {
                        self.logout?()
                    }
                    
                    coordinator.onAuthFlow = {
                        self.onAuthFlow?()
                    }
                    
                    coordinator.onFamilyMemberFlow = {
                        self.onFamilyMemberFlow?()
                    }
                    
                    coordinator.onAuthFlowWithEntry = { (entry) in
                        self.onAuthFlowWithEntry?(entry)
                    }
                    self.addDependency(coordinator)
                    coordinator.start()
                }
            }
        }
    }
    
    func runNotifFlow(deeplink: DeepLinkOption){
        switch deeplink{
        case .appointmentPaymentSuccess(let id):
            goToPaymentFlow?(.paymentReview(id: id))
        case .appointmentCompleted(_):
            goToCompleteConsults?()
        case .appointmentWaitingForPayment(let id):
            goToPaymentFlow?(.waitingForPayment(id: id))
        case .appointmentCancelledByGP(let id), .appointmentCancelledBySystem(let id):
            goToConsultationFlow?(.cancelledBooking(id))
        case .appointmentScheduleChanged(_), .appointmentSpecialistChanged(_):
            goToMyConsultations?()
        case .appointment15BeforeMeet(_), .appointmentMeetSpecialist(_):
            goToMyConsultations?()
        case .appointmentPaymentRefunded(let id):
            goToConsultationFlow?(.cancelledBooking(id))
        case .appointment15AfterOngoing(_):
            goToMyConsultations?()
        case .appointment15ToEndMeet(_):
            goToMyConsultations?()
        }
    }
}
