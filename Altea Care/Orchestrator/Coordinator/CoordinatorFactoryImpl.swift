//
//  CoordinatorFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation
import UIKit

class CoordinatorFactoryImpl: CoordinatorFactory {
    
    // MARK: - Auth
    func makeAuthCoordinator(router: Router) -> Coordinator & AuthenticationCoordinatorOutput {
        return AuthenticationCoordinator(router: router, factory: ModuleFactoryImpl())
    }
    
    // MARK: - Menubar
    func makeMenubarCoordinator() -> (configurator: Coordinator & MenubarCoordinatorOutput, toPresent: Presentable?) {
        let controller = TabbarController.controllerFromStoryboard(.main)
        let coordinator = MenubarCoordinator(tabbarView: controller, coordinatorFactory: CoordinatorFactoryImpl())
        return (coordinator, controller)
    }
    
    
    // MARK: - Dashboard
    func makeDashboardCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & DashboardCoordinatorOutput, toPresent: Presentable?) {
        let router = self.router(navController)
        let coordinator = DashboardCoordinator(router: router, factory: ModuleFactoryImpl(), coordinatorFactory: CoordinatorFactoryImpl())
        return (coordinator, router)
    }
    
    func makeDashboardCoordinator() -> (configurator: Coordinator & DashboardCoordinatorOutput, toPresent: Presentable?) {
        return makeDashboardCoordinator(navController: nil)
    }
    
    
    // MARK: - Booking
    func makeBookingCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & BookingCoordinatorOutput, toPresent: Presentable?) {
        let router = self.router(navController)
        let coordinator = BookingCoordinator(router: router, factory: ModuleFactoryImpl(), coordinatorFactory: CoordinatorFactoryImpl())
        return (coordinator, router)
    }
    
    func makeBookingCoordinator() -> (configurator: Coordinator & BookingCoordinatorOutput, toPresent: Presentable?) {
        return makeBookingCoordinator(navController: nil)
    }
    
    
    // MARK: - Consultation
    func makeConsultationCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & ConsultationCoordinatorOutput, toPresent: Presentable?) {
        let router = self.router(navController)
        let coordinator = ConsultationCoordinator(router: router, factory: ModuleFactoryImpl(), coordinatorFactory: CoordinatorFactoryImpl())
        return (coordinator, router)
    }
    
    func makeConsultationCoordinator() -> (configurator: Coordinator & ConsultationCoordinatorOutput, toPresent: Presentable?) {
        return makeConsultationCoordinator(navController: nil)
    }
    
    
    // MARK: - Payment
    func makePaymentCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & PaymentCoordinatorOutput, toPresent: Presentable?) {
        let router = self.router(navController)
        let coordinator = PaymentCoordinator(router: router, factory: ModuleFactoryImpl(), coordinatorFactory: CoordinatorFactoryImpl())
        return (coordinator, router)
    }
    
    func makePaymentCoordinator() -> (configurator: Coordinator & PaymentCoordinatorOutput, toPresent: Presentable?) {
        return makePaymentCoordinator(navController: nil)
    }
    
    
    // MARK: - Account
    func makeAccountCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & AccountCoordinatorOutput, toPresent: Presentable?) {
        let router = self.router(navController)
        let coordinator = AccountCoordinator(router: router, factory: ModuleFactoryImpl(), coordinatorFactory: CoordinatorFactoryImpl())
        return (coordinator, router)
    }
    
    func makeAccountCoordinator(router: Router) -> (configurator: Coordinator & AccountCoordinatorOutput, toPresent: Presentable?) {
        return makeAccountCoordinator(navController: nil)
    }
    
    // MARK: - Family
    func makeFamilyCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & FamilyCoordinatorOutput, toPresent: Presentable?) {
        let router = self.router(navController)
        let coordinator = FamilyCoordinator(router: router, factory: ModuleFactoryImpl())
        return (coordinator, router)
    }
    
    func makeFamilyCoordinator() -> (configurator: Coordinator & FamilyCoordinatorOutput, toPresent: Presentable?) {
        return makeFamilyCoordinator(navController: nil)
    }
    
    
    //--------------------------------------------------------------------------------------------------
    private func router(_ navController: UINavigationController?) -> Router {
        return RouterImpl(rootController: navigationController(navController))
    }
    
    private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController {
            return navController
        } else {
            return UINavigationController.controllerFromStoryboard(.main)
        }
    }
    
}
