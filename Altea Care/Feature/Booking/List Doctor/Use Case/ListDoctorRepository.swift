//
//  ListDoctorRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol ListDoctorRepository {
    func requestDoctor() -> Single<[ListDoctorModel]>
    func requestDoctorSpecialistList(body: ListDoctorSpecializationBody) -> Single<[ListDoctorModel]>
    func reqeustSearchDoctorSpecialist(q: String) -> Single<[ListDoctorModel]>
    func requestDoctorsSpecialist(body: DoctorsSpecializationBody) -> Single<[ListDoctorModel]>
}
