//
//  DetailDoctorRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class DetailDoctorRepositoryImpl: DetailDoctorRepository {
    
   
    private let disposeBag = DisposeBag()
    private let doctorDetailsAPI : DoctorDetailsAPI
    private let doctorScheduleAPI : DoctorScheduleAPI
    private let termRefundCancelAPI : TermRefundCancelAPI
    
    init(doctorDetailsAPI : DoctorDetailsAPI, doctorSheduleAPI : DoctorScheduleAPI, termRefundCancelAPI : TermRefundCancelAPI) {
        self.doctorDetailsAPI = doctorDetailsAPI
        self.doctorScheduleAPI = doctorSheduleAPI
        self.termRefundCancelAPI = termRefundCancelAPI
    }
    
    func requestDoctorData(id: String) -> Single<DetailDoctorModel> {
        return Single.create { (observer) in
            self.doctorDetailsAPI
                .requestDoctorDetails(id: id)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DoctorDetailsResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .doctorDetailsAPI
                            .httpClient
                            .verify()
                            .andThen(self.doctorDetailsAPI.requestDoctorDetails(id: id))
                    }
                    return Single.error(error)
                }
                .map { self.transformOutputDoctorDataToModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) : observer (.success(model))
                    case .failure(let error) : observer (.failure(error))
                    }
                }, onFailure: { (error) in observer (.failure(error))
                    
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func transformOutputDoctorDataToModel(_ response : DoctorDetailsResponse) -> Result<DetailDoctorModel, HTTPError>{
        if response.status {
            let model = response.data.map { (res) in
                return DetailDoctorModel(doctorId: res.doctorId,
                                         name: res.name,
                                         about: res.about,
                                         overview: res.overview,
                                         language: res.overview,
                                         photo: res.photo?.url ?? "-",
                                         sip: res.sip, experience: res.experience,
                                         idSpecialization: res.specialization.id,
                                         specialization: res.specialization.name,
                                         iconHospital:  "https://cms-bucket-alteacare.s3.ap-southeast-1.amazonaws.com/small_logo_MIKA_83f14601a0.png",
                                         nameHospital: res.hospital[0].name,
                                         idHospital: res.hospital[0].id,
                                         price: res.price.raw,
                                         priceFormatted: res.price.formatted,
                                         promoPriceFormatted: res.flatPrice?.formatted, promoPriceRaw: res.flatPrice?.raw)
            }!
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestDoctorSchedule(body: DoctorScheduleBody) -> Single<(DoctorScheduleModel)> {
        return Single.create { (observer) in
            self.doctorScheduleAPI.request(id: body.idDoctor ?? "", date: body.date ?? "")
                .catch { (error) -> PrimitiveSequence<SingleTrait, DoctorScheduleResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .doctorScheduleAPI
                            .httpClient
                            .verify()
                            .andThen(self.doctorScheduleAPI.request(id: body.idDoctor ?? "", date: body.date ?? ""))
                    }
                    return Single.error(error)
                }
                .map { self.transformOutputScheduleDoctorModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) : observer(.success(model))
                    case .failure(let error) : observer(.failure(error))
                    }
                }, onFailure: { (error) in observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func transformOutputScheduleDoctorModel(_ response :  DoctorScheduleResponse) -> Result<DoctorScheduleModel, HTTPError> {
        if response.status {
            let dataSchedule = response.data.map { (data) in
                
                return DoctorScheduleDataModel(code: data.code, date: data.date, startTime: data.startTime, endTime: data.endTime)
            }
            let model = DoctorScheduleModel(status: response.status, message: response.message, data: dataSchedule)
            
            
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestTermCancelRefund() -> Single<TermRefundCancelModel> {
        return Single.create { (observer) in
            self.termRefundCancelAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, TermRefundCancelResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .termRefundCancelAPI
                            .httpClient
                            .verify()
                            .andThen(self.termRefundCancelAPI.request())
                    }
                    return Single.error(error)
                }
                .map { self.transformOutputTermCancelRefundToModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) : observer(.success(model))
                    case .failure(let error) : observer(.failure(error))
                    }
                }, onFailure: { (error) in observer (.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func transformOutputTermCancelRefundToModel(_ response : TermRefundCancelResponse) -> Result<TermRefundCancelModel, HTTPError> {
        
        if response.status {
            let model = response.data.map { (res) in
                return TermRefundCancelModel(textTermRefund: res.text)
            }!
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
}
