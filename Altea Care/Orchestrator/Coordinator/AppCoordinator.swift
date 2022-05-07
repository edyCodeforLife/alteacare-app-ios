//
//  AppCoordinator.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation
import UIKit

fileprivate enum LaunchInstructor {
    case login, dashboard
    
    static func configure() -> LaunchInstructor {
        return .dashboard
    }
}

final class AppCoordinator: BaseCoordinator {
    
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    private var indexTab: SelectedTabEntry = .tabIndex(5)
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start(with option: DeepLinkOption?, indexTab selectTab: SelectedTabEntry?) {
        self.indexTab = selectTab ?? .tabIndex(5)
        //start with deepLink
        if let option = option {
            self.startWith(deeplink: option)
        } else {
            self.startBasicFlow()
        }
    }
    
    private func startWith(deeplink: DeepLinkOption) {
        self.runMenubarFlow(with: deeplink, index: nil)
    }
    
    override func startWithNotif(with option: DeepLinkOption?){
        if let option = option {
            switch option{
            default: startMenubarWithNotif(deeplink: option)
            }
        }
    }
    
    private func startMenubarWithNotif(deeplink: DeepLinkOption) {
        let top = UIApplication.topViewController()
        if let _ = top as? HomeVC{
            runMenubarFlow(with: deeplink, index: nil)
        }else if let _ = top as? ListConsultationVC{
            runMenubarFlow(with: deeplink, index: nil)
        }else if let _ = top as? HistoryConsultationVC{
            runMenubarFlow(with: deeplink, index: nil)
        }else if let _ = top as? CancelConsultationVC{
            runMenubarFlow(with: deeplink, index: nil)
        }else if let _ = top as? ListConsultationVC{
            runMenubarFlow(with: deeplink, index: nil)
        }else if let _ = top as? ListSpecialistVC{
            runMenubarFlow(with: deeplink, index: nil)
        }else if let _ = top as? AccountVC{
            runMenubarFlow(with: deeplink, index: nil)
        }else{
            self.childCoordinators.forEach{ child in
                if let menu = child as? MenubarCoordinator {
                    menu.runNotifFlow(deeplink: deeplink)
                }
            }
        }
        
    }
    
    private func startBasicFlow() {
        switch self.instructor {
        case .dashboard:
            self.runMenubarFlow(index: nil)
        case .login:
            self.runAuthFlow()
        }
    }
    
    private func runAuthFlow(with option: DeepLinkOption? = nil) {
        var coordinator = coordinatorFactory.makeAuthCoordinator(router: self.router)
        coordinator.onMenubarFlow = { [weak self] in
            guard let self = self else { return }
            self.runMenubarFlow(index: nil)
            self.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runAuthFlow(entry: AuthEntry) {
        var coordinator = coordinatorFactory.makeAuthCoordinator(router: self.router)
        coordinator.onMenubarFlow = { [weak self] in
            guard let self = self else { return }
            self.runMenubarFlow(index: nil)
            self.removeDependency(coordinator)
        }
        
        coordinator.onCloseFromSwitchAcc = { [weak self] in
            guard let self = self else { return }
            self.runMenubarFlow(index: nil)
            self.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start(auth: entry)
    }
    
    private func runMenubarFlow(with option: DeepLinkOption? = nil, index: Int?) {
        var (coordinator, module) = coordinatorFactory.makeMenubarCoordinator()
        
        coordinator.logout = { [weak self] in
            guard let self  = self else { return }
            self.runMenubarFlow(index: nil)
        }
        coordinator.onAuthFlow = { [weak self] in
            guard let self = self else { return }
            self.runAuthFlow()
            //            self.runMenubarFlow()
            self.removeDependency(coordinator)
        }
        
        coordinator.onAuthFlowWithEntry = {[weak self] (entry) in
            guard let self = self else { return }
            self.runAuthFlow(entry: entry)
            self.removeDependency(coordinator)
        }
        
        coordinator.goToPaymentFlow = { [weak self] (entry) in
            guard let self = self else { return }
            self.runPaymentFlow(entry: entry)
        }
        
        coordinator.goToConsultationFlow = { [weak self] (entry) in
            guard let self = self else { return }
            self.runDetailConsultationFlow(entry: entry)
        }
        
        coordinator.goDashboard = { [weak self] in
            guard let self = self else { return }
            self.runMenubarFlow(index: nil)
        }
        
        coordinator.goToMyConsultations = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.router.popToRootModule(animated: true)
                self.runMenubarFlow(with: nil, index: 2)
            }
        }
        
        coordinator.goToCancelledConsultation = {
            [weak self] in
                guard let self = self else { return }
                self.router.dismissModule(animated: true) {
                    self.router.popToRootModule(animated: true)
                    self.runMenubarFlow(with: .appointmentPaymentRefunded(id: 1), index: 2)
                }
        }
        
        coordinator.goToCompleteConsults = {
            [weak self] in
                guard let self = self else { return }
                self.router.dismissModule(animated: true) {
                    self.router.popToRootModule(animated: true)
                    self.runMenubarFlow(with: .appointmentCompleted(id: 1), index: 2)
                }
        }
        
        addDependency(coordinator)
        router.setRootModule(module, hideBar: true, animation: .bottomUp)
        coordinator.start(with: option, indexTab: .tabIndex(index ?? 5))
    }
    
    func runPaymentFlow(entry: PaymentModeEntry) {
        var (coordinator, _) = coordinatorFactory.makePaymentCoordinator(navController: UIApplication.getTopViewController()?.navigationController)
        coordinator.onPaymentReviewed = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
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
        coordinator.start(payment: entry)
    }
    
    func runDetailConsultationFlow(entry: ConsultationModeEntry) {
        var (coordinator, _) = coordinatorFactory.makeConsultationCoordinator(navController: UIApplication.getTopViewController()?.navigationController)
        coordinator.onEndConsultation = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
            }
        }
        
        coordinator.onGoDashboard = { [weak self] in
            guard let self = self else { return }
            self.router.dismissModule(animated: true) {
                self.removeDependency(coordinator)
            }
        }
        
        addDependency(coordinator)
        coordinator.start(consultation: entry)
    }
    
}
