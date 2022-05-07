//
//  MedicalDocumentRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol MedicalDocumentRepository {
    func requestDocumentAPI(body: MedicalDocumentBody) -> Single<[MedicalDocumentModel]>
}
