//
//  ReviewBookingView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol ReviewBookingView: BaseView {
    var viewModel: ReviewBookingVM! { get set }
//    var onReviewed: ((_ id: Int, _ callMA: Bool) -> Void)? { get set }
    var onReviewed: ((_ data: CreateBookingModel?, _ dataPatient : PatientBookingModel?) -> Void)? { get set }
    var changeDataPatientTapped : ((String, String) -> Void)? { get set }
    var dataCreateBooking: CreateBookingModel? { get set }
    var goToAddFamilyMember: (() -> Void)? { get set }
    var patientData: PatientBookingModel? { get set}
}
