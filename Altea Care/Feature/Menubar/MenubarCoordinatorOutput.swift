//
//  MenubarCoordinatorOutput.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol MenubarCoordinatorOutput {
    var onAuthFlow: (() -> Void)? { get set }
    var onAuthFlowWithEntry: ((AuthEntry) -> Void)? { get set }
    var logout:(() -> Void)? { get set }
    var goDashboard:(() -> Void)? { get set }
    var goToContactAltea:(() -> Void)? { get set }
    var goToPaymentFlow: ((PaymentModeEntry) -> Void)? {get set}
    var goToConsultationFlow: ((ConsultationModeEntry) -> Void)? {get set}
    var goToMyConsultations: (() -> Void)? {get set}
    var goToCancelledConsultation: (() -> Void)? {get set}
    var goToCompleteConsults: (() -> Void)? {get set}
}
