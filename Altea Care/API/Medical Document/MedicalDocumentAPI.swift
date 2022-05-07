//
//  MedicalDocumentAPI.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

protocol MedicalDocumentAPI: ClientAPI {
    func request(body: MedicalDocumentBody) -> Single<DetailConsultationResponse>
}
