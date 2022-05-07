//
//  ReceiptConsultationAPI.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

protocol ReceiptConsultationAPI: ClientAPI {
    func request(body: ReceiptConsultationBody) -> Single<DetailConsultationResponse>
}
