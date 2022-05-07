//
//  ListConsultationAPI.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

protocol ListConsultationAPI: ClientAPI {
    func request(parameters: [String: Any], type: ListConsultationType) -> Single<ListConsultationResponse>
}
