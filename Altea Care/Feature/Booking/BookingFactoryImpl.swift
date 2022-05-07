//
//  BookingFactoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation

extension ModuleFactoryImpl: BookingFactory {
    
    func makeListSpecialist(query: String, isShowBackButton: Bool) -> ListSpecialistView {
        let vc = ListSpecialistVC()
        vc.viewModel = makeListSpecialistVM()
        vc.searchQuery = query
        vc.isShowBackButton = isShowBackButton
        return vc
    }
    
    func makeListDoctor() -> ListDoctorView {
        let vc = ListDoctorVC()
        vc.viewModel = makeListDoctorVM()
        return vc
    }
    
    func makeDetailDoctor() -> DetailDoctorView {
        let vc = DetailDoctorVC()
        vc.viewModel = makeDetailDoctorVM()
        return vc
    }
    
    func makeCreateBooking() -> CreateBookingView {
        let vc = CreateBookingVC()
        vc.viewModel = makeCreateBookingVM()
        return vc
    }
    
    func makeReviewBooking() -> ReviewBookingView {
        let vc = ReviewBookingVC()
        vc.viewModel = makeReviewBookingVM()
        return vc
    }
    
    func makeSearchAutocomplete() -> SearchAutocompleteView {
        let vc = SearchAutocompleteVC()
        vc.viewModel = makeSearchAutocompleteVM()
        return vc
    }
    
    func makeLoginConsultation() -> LoginConsultationView {
        let vc = LoginConsultationVC()
        vc.viewModel = makeLoginConsultationVM()
        return vc
    }
    
    func makeDrawerCallBookingView() -> DrawerCallBookingView {
        let vc = DrawerCallBookingVC()
        vc.viewModel = makeDrawerCallBookingVM()
        return vc
    }
    
    func makeListSymtomView(query: String, searchType: search) -> ListSymtomView {
        let vc = ListSymtomViewController()
        vc.query = query
        vc.searchType = searchType
        vc.viewModel = makeSearchResultVM()
        return vc
    }
    
    func makeOutsideOperatingHourViewBooking(setting: SettingModel) -> OutsideOperatingHourView {
        let vc = OutsideOperatingHourViewController()
        vc.setting = setting
        return vc
    }
    
    func makeFilterDoctorView() -> FilterDoctorView {
        let vc =  FilterDoctorVC()
        vc.viewModel = makeFilterDoctorVM()
        return vc
    }
    
    func makeFindFilterView() -> FindFilterView {
        let vc =  FindFilterVC()
        return vc
    }
    
}
