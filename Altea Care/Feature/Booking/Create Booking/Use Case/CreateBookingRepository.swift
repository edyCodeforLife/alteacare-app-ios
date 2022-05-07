//
//  CreateBookingRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol CreateBookingRepository {
    func requestAppointment(id: String) -> Single<CreateBookingModel>
}
