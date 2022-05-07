//
//  DetailDoctorView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol DetailDoctorView: BaseView {
    var viewModel: DetailDoctorVM! { get set }
    var onDatetimeTapped: ((DoctorScheduleDataModel, DetailDoctorModel) -> Void)? { get set }
    var onButtonNextTapped: (() -> Void)? { get set }
    var onButtonSeeAllSchedule: (() -> Void)? { get set }
    var idDoctor: String! { get set }
    var selectedDayName: DayName? { get set }
    var dataDateTimeSelected: DoctorScheduleDataModel! { get set}
    var isFormListDoctor: Bool! { get set }
    var goToAddFamilyMember: (() -> Void)? { get set }
    var goToLogin: ((String, String) -> Void)? { get set }
}
