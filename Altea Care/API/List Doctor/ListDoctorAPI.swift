//
//  ListDoctorAPI.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 03/05/21.
//

import Foundation
import RxSwift

protocol ListDoctorAPI: ClientAPI {
    func requestDoctorList() -> Single<ListDoctorResponse>
    func requestDoctorSpecializationList(id: String, day: String?, q: String) -> Single<ListDoctorResponse>
    func requestDoctorSpecialization(body: DoctorsSpecializationBody) -> Single<ListDoctorResponse>
}
