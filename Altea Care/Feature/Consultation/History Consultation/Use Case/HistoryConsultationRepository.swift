//
//  HistoryConsultationRepository.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import RxSwift

protocol HistoryConsultationRepository {
    func requestList(body: ListConsultationBody) -> Single<HistoryConsultation>
    func requestListPatient() -> Single<ListMemberModel>
}
