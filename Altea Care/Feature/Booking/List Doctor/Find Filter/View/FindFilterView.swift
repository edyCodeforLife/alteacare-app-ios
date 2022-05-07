//
//  FindFilterView.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 29/12/21.
//

import Foundation

protocol FindFilterView: BaseView {
    var typeSelected: TypeTagCollection! { get set }
    var daySelected: FilterList! { get set }
    var tagSelected: [FilterList]! { get set }
    var specializations: [ListSpecialistModel]! { get set }
    var hospitals: [ListHospitalModel]! { get set }
    var doctors: [ListDoctorModel]! { get set }
    var onCloseView: (() -> Void)? { get set }
    var onFindFilterTapped: ((FilterList, [FilterList]) -> Void)? { get set }
}
