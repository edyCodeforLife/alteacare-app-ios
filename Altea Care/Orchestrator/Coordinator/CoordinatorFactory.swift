//
//  CoordinatorFactory.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation
import UIKit

protocol CoordinatorFactory {
    // MARK: - Auth
    func makeAuthCoordinator(router: Router) -> Coordinator & AuthenticationCoordinatorOutput
    
    // MARK: - Menubar
    func makeMenubarCoordinator() -> (configurator: Coordinator & MenubarCoordinatorOutput, toPresent: Presentable?)
    
    // MARK: - Account
    func makeAccountCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & AccountCoordinatorOutput, toPresent: Presentable?)
    func makeAccountCoordinator(router: Router) -> (configurator: Coordinator & AccountCoordinatorOutput, toPresent: Presentable?)
    
    
    // MARK: - Dashboard
    func makeDashboardCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & DashboardCoordinatorOutput, toPresent: Presentable?)
    func makeDashboardCoordinator() -> (configurator: Coordinator & DashboardCoordinatorOutput, toPresent: Presentable?)
    
    // MARK: - Booking
    func makeBookingCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & BookingCoordinatorOutput, toPresent: Presentable?)
    func makeBookingCoordinator() -> (configurator: Coordinator & BookingCoordinatorOutput, toPresent: Presentable?)
    
    // MARK: - Consultation
    func makeConsultationCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & ConsultationCoordinatorOutput, toPresent: Presentable?)
    func makeConsultationCoordinator() -> (configurator: Coordinator & ConsultationCoordinatorOutput, toPresent: Presentable?)
    
    // MARK: - Payment
    func makePaymentCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & PaymentCoordinatorOutput, toPresent: Presentable?)
    func makePaymentCoordinator() -> (configurator: Coordinator & PaymentCoordinatorOutput, toPresent: Presentable?)
    
    // MARK: - Family
    func makeFamilyCoordinator(navController: UINavigationController?) -> (configurator: Coordinator & FamilyCoordinatorOutput, toPresent: Presentable?)
    func makeFamilyCoordinator() -> (configurator: Coordinator & FamilyCoordinatorOutput, toPresent: Presentable?)

}
