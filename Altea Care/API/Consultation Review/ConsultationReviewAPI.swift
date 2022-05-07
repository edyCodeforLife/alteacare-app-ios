//
//  ConsultationReviewAPI.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

protocol ConsultationReviewAPI: ClientAPI {
    func request(id: String) -> Single<ConsultationReviewResponse>
}
