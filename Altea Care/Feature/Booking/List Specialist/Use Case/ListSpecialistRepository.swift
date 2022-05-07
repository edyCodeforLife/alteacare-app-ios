//
//  ListSpecialistRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol ListSpecialistRepository {
    func requestSpecializations(_ req: SpecializationsRequest) -> Single<[ListSpecialistModel]>
    func requestSpecializations(_ q: String) -> Single<[ListSpecialistModel]>
}
