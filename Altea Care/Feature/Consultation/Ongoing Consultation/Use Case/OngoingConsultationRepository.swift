//
//  OngoingConsultationRepository.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import RxSwift

protocol OngoingConsultationRepository {
    func requestList(body: ListConsultationBody) -> Single<OngoingConsultation>
    func requestListPatient() -> Single<ListMemberModel>
}
