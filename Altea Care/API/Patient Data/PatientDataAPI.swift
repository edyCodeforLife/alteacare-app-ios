//
//  PatientDataAPI.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

protocol PatientDataAPI: ClientAPI {
    func request(body: PatientDataBody) -> Single<DetailConsultationResponse>
}
