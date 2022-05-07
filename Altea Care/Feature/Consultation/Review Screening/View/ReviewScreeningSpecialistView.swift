//
//  ReviewScreeningSpecialistView.swift
//  Altea Care
//
//  Created by Admin on 5/4/21.
//

import Foundation

protocol ReviewScreeningSpecialistView: BaseView {
    var viewModel: ReviewScreeningVM! { get set }
    var onCheckMedicalResume: (() -> Void)? { get set }
    var doctor: DoctorCardModel? { get set }
    var appointmentId: String! { get set }
    var endTime: String? { get set }
}
