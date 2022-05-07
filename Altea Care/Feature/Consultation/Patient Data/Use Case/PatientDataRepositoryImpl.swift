//
//  PatientDataRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class PatientDataRepositoryImpl: PatientDataRepository {
    
    private let disposeBag = DisposeBag()
    private let patientDataAPI: PatientDataAPI
    private let uploadDocumentAPI: UploadDocumentAPI
    private let bindDocumentAPI: BindDocumentAPI
    private let removeDocumentAPI: RemoveDocumentAPI
    
    init(patientDataAPI: PatientDataAPI, uploadDocumentAPI: UploadDocumentAPI, bindDocumentAPI: BindDocumentAPI, removeDocumentAPI: RemoveDocumentAPI) {
        self.patientDataAPI = patientDataAPI
        self.uploadDocumentAPI = uploadDocumentAPI
        self.bindDocumentAPI = bindDocumentAPI
        self.removeDocumentAPI = removeDocumentAPI
    }
    
    func requestPatientData(body: PatientDataBody) -> Single<PatientDataModel> {
        return Single.create { (observer) in
            self.patientDataAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DetailConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .patientDataAPI
                            .httpClient
                            .verify()
                            .andThen(self.patientDataAPI
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
    
    func requestDeleteDocument(body: RemoveDocumentBody) -> Single<Bool> {
        return Single.create { (observer) in
            self.removeDocumentAPI
                .request(body: body.dictionary ?? [String:Any]())
                .catch { (error) -> PrimitiveSequence<SingleTrait, RemoveDocumentResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .removeDocumentAPI
                            .httpClient
                            .verify()
                            .andThen(self.removeDocumentAPI
                                        .request(body: body.dictionary ?? [String:Any]()))
                    }
                    return Single.error(error)
                }
                .map { self.transformRemoveResponse($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let status):
                        observer(.success(status))
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
    
    func requestUploadDocument(media: Media, boundary: String) -> Single<String> {
        return Single.create { (observer) in
            self.uploadDocumentAPI
                .request(media: media, boundary: boundary)
                .catch { (error) -> PrimitiveSequence<SingleTrait, UploadDocumentResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .uploadDocumentAPI
                            .httpClient
                            .verify()
                            .andThen(self.uploadDocumentAPI
                                        .request(media: media, boundary: boundary))
                    }
                    return Single.error(error)
                }
                .map { self.transformUploadResponse($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let status):
                        observer(.success(status))
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
    
    func requestBindDocument(body: BindDocumentBody) -> Single<Bool> {
        return Single.create { (observer) in
            self.bindDocumentAPI
                .request(parameters: body.dictionary ?? [String: Any]())
                .catch { (error) -> PrimitiveSequence<SingleTrait, BindDocumentResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .bindDocumentAPI
                            .httpClient
                            .verify()
                            .andThen(self.bindDocumentAPI
                                        .request(parameters: body.dictionary ?? [String: Any]()))
                    }
                    return Single.error(error)
                }
                .map { self.transformBindResponse($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let status):
                        observer(.success(status))
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
    
    private func outputTransformModel(_ response: DetailConsultationResponse) -> Result<PatientDataModel, HTTPError> {
        if response.status {
            if let data = response.data {
                let doctor = DoctorCardModel(id: data.doctor.id, doctorImage: data.doctor.photo?.url, hospitalIcon: data.doctor.hospital.logo, name: data.doctor.name, specialty: "\(data.doctor.specialist.name)", hospitalName: data.doctor.hospital.name, date: data.schedule.date, time: "\(data.schedule.timeStart ?? "") - \(data.schedule.timeEnd ?? "")", hospitalId: data.doctor.hospital.id)
                
                let documents = data.medicalDocument.filter{ $0.uploadByUser == 1 }.map { (doc) in
                    return MedicalDocumentItem(id: doc.id,title: doc.originalName, size: doc.size, date: "", url: doc.url, isUploadByUser: doc.uploadByUser == 0 ? false : true)
                }
                
                let schedule = Schedule(date: data.schedule.date.dateFormattedUS(),dateString: data.schedule.date, timeStart: data.schedule.timeStart ?? "", timeEnd: data.schedule.timeEnd ?? "", time: "\(data.schedule.timeStart ?? "") - \(data.schedule.timeEnd ?? "")")
                
                let appointment = Appointment(id: data.id, orderCode: data.orderCode)
                
                let model = PatientDataModel(name: data.user.name, age: "\(data.user.age.year) Tahun \(data.user.age.month) Bulan", birthday: String().toDate(format: data.user.birthdate), sex: SexFormatter.formatted(data.user.gender), idCard: data.user.cardId, phone: data.user.phoneNumber, email: data.user.email, address: data.user.addressRaw?.first?.fullAdress, status: ConsultationStatus(rawValue: data.status) ?? .unknown, doctor: doctor, documents: documents, diagnosis: data.medicalResume?.diagnosis, schedule: schedule, appointment: appointment)
                
                return .success(model)
            }
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    private func transformRemoveResponse(_ response: RemoveDocumentResponse) -> Result<Bool, HTTPError> {
        if response.status {
            return .success(true)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    private func transformUploadResponse(_ response: UploadDocumentResponse) -> Result<String, HTTPError> {
        if let data = response.data, response.status {
            return .success(data.id)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    private func transformBindResponse(_ response: BindDocumentResponse) -> Result<Bool, HTTPError> {
        if response.status {
            return .success(true)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
