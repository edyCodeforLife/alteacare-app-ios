//
//  ConsulationExpiredView.swift
//  Altea Care
//
//  Created by Hedy on 17/03/21.
//

import Foundation

protocol ConsulationExpiredView: BaseView {
    var model: CancelConsultationModel? { get set }
    var idAppointment: Int! { get set }
    var isRoot : Bool { get set }
    var onClosed: (() -> Void)? { get set }
}
