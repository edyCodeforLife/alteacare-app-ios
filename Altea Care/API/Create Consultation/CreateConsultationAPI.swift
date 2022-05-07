//
//  CreateConsultationAPI.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 31/05/21.
//

import Foundation
import RxSwift

protocol CreateConsultationAPI: ClientAPI {
    func request(parameters: [String:Any]) -> Single<CreateConsultationResponse>
}
