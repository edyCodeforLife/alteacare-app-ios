//
//  ConsultationCoordinatorOutput.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol ConsultationCoordinatorOutput {
    var onEndConsultation: (() -> Void)? { get set }
    var onCancelConsultation: (() -> Void)? { get set }
    var onCloseConsultation: (() -> Void)? { get set }
    var onGoDashboard : (() -> Void)? { get set }
    var onGoConsultation : (() -> Void)? {get set}
    var onDetailConsultation: (() -> Void)? { get set }
}
