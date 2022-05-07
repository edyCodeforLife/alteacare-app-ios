//
//  DoctorScheduleAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/05/21.
//

import Foundation
import RxSwift

protocol DoctorScheduleAPI : ClientAPI {
    func request(id : String, date : String) -> Single<DoctorScheduleResponse>
}
