//
//  FilterListHospitalRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//

import Foundation
import RxSwift

protocol FilterListHospitalRepository {
    func requestListHospital() -> Single<ListHospitalModel>
    func requestHospitals() -> Single<[ListHospitalModel]>
}
