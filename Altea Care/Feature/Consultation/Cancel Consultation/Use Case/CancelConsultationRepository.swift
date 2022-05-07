//
//  CancelConsultationRepository.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import RxSwift

protocol CancelConsultationRepository {
    func requestList(body: ListConsultationBody) -> Single<CancelConsultation>
    func requestListPatient() -> Single<ListMemberModel>
}
