//
//  DrawerCallBookingRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 02/08/21.
//

import Foundation
import RxSwift

protocol DrawerCallBookingRepository {
    func requestConsultation(body : CreateConsultationBody) -> Single<DataCreateConsultation>
}
