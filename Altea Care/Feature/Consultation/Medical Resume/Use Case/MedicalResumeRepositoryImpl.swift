//
//  MedicalResumeRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class MedicalResumeRepositoryImpl: MedicalResumeRepository {
    
    private let disposeBag = DisposeBag()
    private let medicalResumeAPI: MedicalResumeAPI
    
    init(medicalResumeAPI: MedicalResumeAPI) {
        self.medicalResumeAPI = medicalResumeAPI
    }
    
    
    func requestMedicalResumeAPI(body: MedicalResumeBody) -> Single<[MedicalResumeModel]> {
        return Single.create { (observer) in
            self.medicalResumeAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DetailConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .medicalResumeAPI
                            .httpClient
                            .verify()
                            .andThen(self.medicalResumeAPI
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
    
    private func outputTransformModel(_ response: DetailConsultationResponse) -> Result<[MedicalResumeModel], HTTPError> {
        if response.status {
            if let data = response.data {
// MARK: - Uncomment when merge
                if data.medicalResume == nil {
                    let dataNil = MedicalResumeModel(title: "-", buttonName: "", url: "", textViewText: "")
                    let model : [MedicalResumeModel] = [dataNil]
                    return .success(model)
                } else {
                    let history = MedicalResumeModel(title: "Keluhan",
                                                     buttonName: "",
                                                     url: "",
                                                     textViewText: data.medicalResume?.symptom ?? "")
                    let diagnosis = MedicalResumeModel(title: "Diagnosis",
                                                     buttonName: "",
                                                     url: "",
                                                     textViewText: data.medicalResume?.diagnosis ?? "")
                    let medicine = MedicalResumeModel(title: "Resep Obat",
                                                     buttonName: "",
                                                     url: "",
                                                     textViewText: data.medicalResume?.drugResume ?? "")
                    let additional = MedicalResumeModel(title: "Pemeriksaan Penunjang",
                                                     buttonName: "",
                                                     url: "",
                                                     textViewText: data.medicalResume?.additionalResume ?? "")
                    let note = MedicalResumeModel(title: "Catatan",
                                                     buttonName: "",
                                                     url: "",
                                                     textViewText: data.medicalResume?.notes ?? "")
                    
                    let model : [MedicalResumeModel] = [history,diagnosis,medicine,additional,note]
                    
                    return .success(model)
                }
                
                
                
// MARK: - Comment when merge
//                let history = MedicalResumeModel(title: "Gejala",
//                                                 buttonName: "",
//                                                 url: "",
//                                                 textViewText: "")
//                let diagnosis = MedicalResumeModel(title: "Diagnosis",
//                                                 buttonName: "",
//                                                 url: "",
//                                                 textViewText: "")
//                let medicine = MedicalResumeModel(title: "Drug Resume",
//                                                 buttonName: "",
//                                                 url: "",
//                                                 textViewText: "")
//                let additional = MedicalResumeModel(title: "Additional Resume",
//                                                 buttonName: "",
//                                                 url: "",
//                                                 textViewText: "")
//                let recom = MedicalResumeModel(title: "Consultation",
//                                                 buttonName: "",
//                                                 url: "",
//                                                 textViewText: "")
//                let note = MedicalResumeModel(title: "Catatan Lain",
//                                                 buttonName: "",
//                                                 url: "",
//                                                 textViewText: "")
                
                
            }
        }
        return .failure(HTTPError.custom(response.message))
    }
    
}
