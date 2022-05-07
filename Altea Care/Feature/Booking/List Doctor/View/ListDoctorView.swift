//
//  ListDoctorView.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation

protocol ListDoctorView: BaseView {
    var viewModel: ListDoctorVM! { get set }
    var onDoctorTapped: ((String, Bool, DayName?) -> Void)? { get set }
    var idSpecialist: String! { get set }
    var nameSpecialist: String! { get set }
    var isSearch: Bool! { get set }
    var inputSearch: String? { get set }
    var backPreviousPage: (() -> Void)? {get set}
    var isBackToPreviousPage: Bool! { get set }
    var isHiddenChipsbar: Bool! { get set }
    var onShowFilterTapped: (([DayName], [ListSpecialistModel], [ListHospitalModel], [ListDoctorModel], [ListPrice], FilterList, [FilterList]) -> Void)? { get set }
    func onSubmitFilter(dayTag: FilterList, dataTag: [FilterList])
    func onSubmitFindFilter(dayTag: FilterList, dataTag: [FilterList])
    func onDismissFindFilter(dayTag: FilterList, dataTag: [FilterList])
}
