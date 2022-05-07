//
//  MedicalResumeRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol MedicalResumeRepository {
    func requestMedicalResumeAPI(body: MedicalResumeBody) -> Single<[MedicalResumeModel]>
}
