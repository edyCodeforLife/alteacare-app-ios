//
//  PatientDataRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol PatientDataRepository {
    func requestPatientData(body: PatientDataBody) -> Single<(PatientDataModel)>
    func requestDeleteDocument(body: RemoveDocumentBody) -> Single<Bool>
    func requestUploadDocument(media: Media, boundary: String) -> Single<String>
    func requestBindDocument(body: BindDocumentBody) -> Single<Bool>
}
