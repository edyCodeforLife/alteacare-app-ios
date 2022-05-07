//
//  ReviewScreeningRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol ReviewScreeningRepository {
    func requestScreeningReview(body: ScreeningReviewBody) -> Single<ReviewScreeningModel>
    func requestConsultationReview(body: ConsultationReviewBody) -> Single<ReviewScreeningModel>
    func requestPatientData(body: PatientDataBody) -> Single<PatientDataModel>
}
