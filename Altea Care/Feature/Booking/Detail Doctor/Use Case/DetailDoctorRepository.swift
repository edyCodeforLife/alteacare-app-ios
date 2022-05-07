//
//  DetailDoctorRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol DetailDoctorRepository {
    func requestDoctorData(id : String) -> Single<DetailDoctorModel>
    func requestDoctorSchedule(body : DoctorScheduleBody) -> Single<(DoctorScheduleModel)>
    func requestTermCancelRefund() -> Single<TermRefundCancelModel>
}
