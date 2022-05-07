//
//  ListDoctorRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class ListDoctorRepositoryImpl: ListDoctorRepository {
    private let doctorListApi : ListDoctorAPI
    private let searchDoctorSpecialistApi: SearchAPI
    private let disposeBag = DisposeBag()
    
    init(api: ListDoctorAPI, apiSearch: SearchAPI) {
        self.doctorListApi = api
        self.searchDoctorSpecialistApi = apiSearch
    }
    
    func requestDoctor() -> Single<[ListDoctorModel]> {
        return Single.create { (observer) in
            self.doctorListApi.requestDoctorList()
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, ListDoctorResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .doctorListApi
                            .httpClient
                            .verify()
                            .andThen(self.doctorListApi.requestDoctorList())
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(
                    onSuccess: { (result) in
                        switch result {
                        case .success(let model) : observer(.success(model))
                        case .failure(let error) : observer(.failure(error))
                        }
                    }, onFailure: { (error) in observer(.failure(error))
                    })
                .disposed(by:self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func reqeustSearchDoctorSpecialist(q: String) -> Single<[ListDoctorModel]> {
        return Single.create { (observer) in
            self.searchDoctorSpecialistApi.requestEverything(q: q)
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, SearchResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .searchDoctorSpecialistApi
                            .httpClient
                            .verify()
                            .andThen(self.searchDoctorSpecialistApi.requestEverything(q: q))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformSearchModel($0) }
                .subscribe(
                    onSuccess: { (result) in
                        switch result {
                        case .success(let model) : observer(.success(model))
                        case .failure(let error) : observer(.failure(error))
                        }
                    }, onFailure: { (error) in observer(.failure(error))
                    })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func requestDoctorsSpecialist(body: DoctorsSpecializationBody) -> Single<[ListDoctorModel]> {
        return Single.create { (observer) in
            self.doctorListApi.requestDoctorSpecialization(body: body)
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, ListDoctorResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .doctorListApi
                            .httpClient
                            .verify()
                            .andThen(self.doctorListApi.requestDoctorSpecialization(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(
                    onSuccess: { (result) in
                        switch result {
                        case .success(let model) : observer(.success(model))
                        case .failure(let error) : observer(.failure(error))
                        }
                    }, onFailure: { (error) in observer(.failure(error))
                    })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func requestDoctorSpecialistList(body: ListDoctorSpecializationBody) -> Single<[ListDoctorModel]> {
        return Single.create { (observer) in
            self.doctorListApi.requestDoctorSpecializationList(id: body.id, day: body.available_day, q: body.query)
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, ListDoctorResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .doctorListApi
                            .httpClient
                            .verify()
                            .andThen(self.doctorListApi.requestDoctorSpecializationList(id: body.id, day: body.available_day, q: body.query))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(
                    onSuccess: { (result) in
                        switch result {
                        case .success(let model) : observer(.success(model))
                        case .failure(let error) : observer(.failure(error))
                        }
                    }, onFailure: { (error) in observer(.failure(error))
                    })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: ListDoctorResponse) -> Result<[ListDoctorModel], HTTPError> {
        if response.status {
            let model = response.data.map { (res) in
                
                return ListDoctorModel(doctorId: res.doctorId ?? "-",
                                       experience: res.experience ?? "-",
                                       imagePerson: res.photo?.url ?? "-",
                                       name: res.name ?? "-",
                                       overview: res.overview ?? "-",
                                       rawPrice: Double(res.price.raw ?? 0),
                                       formattedPrice: res.price.formatted ?? "-",
                                       specialization: "\(res.specialization?.name ?? "-")",
                                       about:  res.about ?? "-",
                                       imageHospital: "https://cms-bucket-alteacare.s3.ap-southeast-1.amazonaws.com/small_logo_MIKA_83f14601a0.png",
                                       nameHospital: res.hospital?.first?.name ?? "",
                                       promoPriceFormatted: res.flatPrice?.formatted ?? "",
                                       promoPriceRaw: Double(res.flatPrice?.raw ?? 0),
                                       isAvailable: res.isAvailable,
                                       isFree: (Double(res.price.raw ?? 0) == 0.0))
            }
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    private func outputTransformSearchModel(_ response: SearchResponse) -> Result<[ListDoctorModel], HTTPError> {
        if response.status {
            let model = response.data.doctor.map { (res) in
                
                return ListDoctorModel(doctorId: res.doctorId ?? "-",
                                       experience: res.experience ?? "-",
                                       imagePerson: res.photo?.url ?? "-",
                                       name: res.name ?? "-",
                                       overview: res.overview ?? "-",
                                       rawPrice: Double(res.price.raw ?? 0),
                                       formattedPrice: res.price.formatted ?? "-",
                                       specialization: "\(res.specialization?.name ?? "-")",
                                       about:  res.about ?? "-",
                                       imageHospital: "https://cms-bucket-alteacare.s3.ap-southeast-1.amazonaws.com/small_logo_MIKA_83f14601a0.png",
                                       nameHospital: res.hospital[0].name ?? "",
                                       promoPriceFormatted: res.flatPrice?.formatted ?? "",
                                       promoPriceRaw: Double(res.flatPrice?.raw ?? 0),
                                       isAvailable: res.isAvailable,
                                       isFree: (Double(res.price.raw ?? 0) == 0.0))
            }
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
}

