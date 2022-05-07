//
//  ReceiptRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol ReceiptRepository {
    func requestReceiptAPI(body: ReceiptConsultationBody) -> Single<ReceiptModel>
}
