//
//  DashboardCoordinatorOutput.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol DashboardCoordinatorOutput {
    var onAuthFlow: (() -> Void)? { get set }
    var onAuthFlowWithEntry: ((AuthEntry) -> Void)? { get set }
    var onEndConsultations: (() -> Void)? {get set}
    var goToMyConsultation: (() -> Void)? {get set}
    var goToDoctorSpecialist: (() -> Void)? {get set}
    var goToCancelledConsultation: (() -> Void)? {get set}
    var goToCompleteConsults: (() -> Void)? {get set}

}

