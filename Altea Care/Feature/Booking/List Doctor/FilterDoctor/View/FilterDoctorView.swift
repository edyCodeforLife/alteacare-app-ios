//
//  FilterDoctorView.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 20/12/21.
//

import Foundation

protocol FilterDoctorView: BaseView {
    var viewModel: FilterDoctorVM! { get set }
    var daysData: [DayName]! { get set }
    var specializationsData: [ListSpecialistModel]! { get set }
    var hospitalsData: [ListHospitalModel]! { get set }
    var doctorsData: [ListDoctorModel]! { get set }
    var pricesData: [ListPrice]! { get set }
    var daySelected: FilterList! { get set }
    var tagSelected: [FilterList]! { get set }
    var onShowAllTapped: ((TypeTagCollection, FilterList, [FilterList]) -> Void)? { get set }
    var onFilterTapped: ((FilterList, [FilterList]) -> Void)? { get set }
}
