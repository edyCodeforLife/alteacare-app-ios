//
//  CreateBookingView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol CreateBookingView: BaseView {
    var viewModel: CreateBookingVM! { get set }
    var onCreated: ((_ data: CreateBookingModel?, _ dataPatient : PatientBookingModel?) -> Void)? { get set }
    var changeDoctorTapped: (() -> Void)? { get set }
    var changePatientDataTapped: ((String, String) -> Void)? { get set }
    var dataDateTimeSelected: DoctorScheduleDataModel! { get set}
    var dataDoctor: DetailDoctorModel! { get set}
    var patientData: PatientBookingModel! { get set}
    var goToLogin: (() -> Void)? { get set }
    var goToAddFamilyMember: (() -> Void)? { get set }
}
