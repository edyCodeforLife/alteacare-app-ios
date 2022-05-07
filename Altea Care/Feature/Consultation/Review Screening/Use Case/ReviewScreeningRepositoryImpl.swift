//
//  ReviewScreeningRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class ReviewScreeningRepositoryImpl: ReviewScreeningRepository {
    
    private let disposeBag = DisposeBag()
    private let screeningReviewAPI: ScreeningReviewAPI
    private let consultationReviewAPI: ConsultationReviewAPI
    private let patientDataAPI: PatientDataAPI
    
    init(screeningReviewAPI: ScreeningReviewAPI, consultationReviewAPI: ConsultationReviewAPI, patientDataAPI: PatientDataAPI) {
        self.screeningReviewAPI = screeningReviewAPI
        self.consultationReviewAPI = consultationReviewAPI
        self.patientDataAPI = patientDataAPI
    }
    
    func requestScreeningReview(body: ScreeningReviewBody) -> Single<ReviewScreeningModel> {
        return Single.create { (observer) in
            self.screeningReviewAPI
                .request(id: body.id)
                .catch { (error) -> PrimitiveSequence<SingleTrait, ScreeningReviewResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .screeningReviewAPI
                            .httpClient
                            .verify()
                            .andThen(self.screeningReviewAPI
                                        .request(id: body.id))
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
    
    private func outputTransformModel(_ response: ScreeningReviewResponse) -> Result<ReviewScreeningModel, HTTPError> {
        return .success(ReviewScreeningModel())
    }
    
    func requestConsultationReview(body: ConsultationReviewBody) -> Single<ReviewScreeningModel> {
        return Single.create { (observer) in
            self.consultationReviewAPI
                .request(id: body.id)
                .catch { (error) -> PrimitiveSequence<SingleTrait, ConsultationReviewResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .consultationReviewAPI
                            .httpClient
                            .verify()
                            .andThen(self.consultationReviewAPI
                                        .request(id: body.id))
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
    
    private func outputTransformModel(_ response: ConsultationReviewResponse) -> Result<ReviewScreeningModel, HTTPError> {
        return .success(ReviewScreeningModel())
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
    
    private func outputTransformModel(_ response: DetailConsultationResponse) -> Result<PatientDataModel, HTTPError> {
        if response.status {
            if let data = response.data {
                let doctor = DoctorCardModel(id: data.doctor.id, doctorImage: data.doctor.photo?.url, hospitalIcon: data.doctor.hospital.logo, name: data.doctor.name, specialty: "Sp \(data.doctor.specialist.name) - ", hospitalName: data.doctor.hospital.name, date: data.schedule.date, time: "\(data.schedule.timeStart ?? "") - \(data.schedule.timeEnd ?? "")", hospitalId: data.doctor.hospital.id)
                
                let documents = data.medicalDocument.filter{ $0.uploadByUser == 1 }.map { (doc) in
                    return MedicalDocumentItem(id: doc.id,title: doc.originalName, size: doc.size, date: "", url: doc.url, isUploadByUser: doc.uploadByUser == 0 ? false : true)
                }
                
                let schedule = Schedule(date: data.schedule.date.dateFormattedUS(),dateString: data.schedule.date, timeStart: data.schedule.timeStart ?? "", timeEnd: data.schedule.timeEnd ?? "", time: "\(data.schedule.timeStart ?? "") - \(data.schedule.timeEnd ?? "")")
                
                let appointment = Appointment(id: data.id, orderCode: data.orderCode)
                
                let model = PatientDataModel(name: data.user.name, age: "\(data.user.age.year) Tahun \(data.user.age.month) Bulan", birthday: data.user.birthdate.dateFormatted(), sex: SexFormatter.formatted(data.user.gender), idCard: data.user.cardId, phone: data.user.phoneNumber, email: data.user.email, address: data.user.addressRaw?.first?.fullAdress, status: ConsultationStatus(rawValue: data.status) ?? .unknown, doctor: doctor, documents: documents, diagnosis: data.medicalResume?.diagnosis, schedule: schedule, appointment: appointment)
                return .success(model)
            }
        }
        return .failure(HTTPError.custom(response.message))
    }
}
