//
//  ConsultationExpiredRepository.swift
//  Altea Care
//
//  Created by Tiara Mahardika on 17/11/21.
//

import Foundation
import RxSwift

protocol ConsultationExpiredRepository {
    func requestAppointmentDetail(body : DetailAppointmentBody) -> Single<CancelConsultationModel>
}
