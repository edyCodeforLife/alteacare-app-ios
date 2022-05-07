//
//  MedicalDocumentRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//
import Foundation
import RxSwift

class MedicalDocumentRepositoryImpl: MedicalDocumentRepository {
    
    private let disposeBag = DisposeBag()
    private let medicalDocumentAPI: MedicalDocumentAPI
    
    init(medicalDocumentAPI: MedicalDocumentAPI) {
        self.medicalDocumentAPI = medicalDocumentAPI
    }
    
    func requestDocumentAPI(body: MedicalDocumentBody) -> Single<[MedicalDocumentModel]> {
        return Single.create { (observer) in
            self.medicalDocumentAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DetailConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .medicalDocumentAPI
                            .httpClient
                            .verify()
                            .andThen(self.medicalDocumentAPI
                                        .request(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: DetailConsultationResponse) -> Result<[MedicalDocumentModel], HTTPError> {
        if let data = response.data {
            let model = data.medicalDocument.map { (doc) in
                return MedicalDocumentItem(id: doc.id, title: doc.originalName, size: doc.size, date: "", url: doc.url, isUploadByUser: doc.uploadByUser == 0 ? false : true)
            }
            let admin = MedicalDocumentModel(title: "Dokumen dari AlteaCare", content: model.filter { !$0.isUploadByUser })
            let user = MedicalDocumentModel(title: "Unggahan Saya", content: model.filter { $0.isUploadByUser })
            return .success([admin, user])
        }
        
        let admin = MedicalDocumentModel(title: "Dokumen dari AlteaCare", content: [])
        let user = MedicalDocumentModel(title: "Unggahan Saya", content: [])
        return .success([admin, user])
    }
    
}
