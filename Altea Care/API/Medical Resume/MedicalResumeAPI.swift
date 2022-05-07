//
//  MedicalResumeAPI.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

protocol MedicalResumeAPI: ClientAPI {
    func request(body: MedicalResumeBody) -> Single<DetailConsultationResponse>
}
