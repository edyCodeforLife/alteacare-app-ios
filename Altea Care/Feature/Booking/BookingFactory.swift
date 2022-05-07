//
//  BookingFactory.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

protocol BookingFactory {
    func makeListSpecialist(query: String, isShowBackButton: Bool) -> ListSpecialistView
    func makeListDoctor() -> ListDoctorView
    func makeDetailDoctor() -> DetailDoctorView
    func makeCreateBooking() -> CreateBookingView
    func makeReviewBooking() -> ReviewBookingView
    func makeSearchAutocomplete() -> SearchAutocompleteView
    func makeLoginConsultation() -> LoginConsultationView
    func makeDrawerCallBookingView() -> DrawerCallBookingView
    func makeListSymtomView(query: String, searchType: search) -> ListSymtomView
    func makeOutsideOperatingHourViewBooking(setting: SettingModel) -> OutsideOperatingHourView
    func makeFilterDoctorView() -> FilterDoctorView
    func makeFindFilterView() -> FindFilterView
}
