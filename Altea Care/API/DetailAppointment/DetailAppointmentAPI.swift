//
//  DetailAppointmentAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 06/07/21.
//

import Foundation
import RxSwift

protocol DetailAppointmentAPI : ClientAPI {
    func requestDetailAppointment(body : DetailAppointmentBody) -> Single<DetailAppointmentResponse>
}
