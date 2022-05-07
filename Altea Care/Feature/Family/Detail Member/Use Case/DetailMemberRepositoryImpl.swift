//
//  DetailMemberRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

class DetailMemberRepositoryImpl: DetailMemberRepository {
  
    
    private let deleteMemberAPI: DeleteMemberAPI
    private let detailMemberAPI: DetailMemberAPI
    private let disposeBag = DisposeBag()
    
    init(detailMemberAPI: DetailMemberAPI, deleteMemberAPI : DeleteMemberAPI) {
        self.detailMemberAPI = detailMemberAPI
        self.deleteMemberAPI = deleteMemberAPI
    }
    
    func requestDetail(body: DetailMemberBody) -> Single<DetailMemberModel> {
        return Single.create { (observer) in
            self.detailMemberAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DetailMemberResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .detailMemberAPI
                            .httpClient
                            .verify()
                            .andThen(self.detailMemberAPI.request(body: body))
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
    
    private func outputTransformModel(_ response: DetailMemberResponse) -> Result<DetailMemberModel, HTTPError> {
        if response.status {
            let data = response.data
            let model = DetailMemberModel(id: data?.id ?? "",
                                          relationship: data?.familyRelationType.name,
                                          firstName: data?.firstName,
                                          lastName: data?.lastName,
                                          gender: SexFormatter.formatted("\(data?.gender ?? "")"),
                                          dob: data?.birthDate.dateIndonesia(),
                                          age: "\(data?.age.year ?? 0)",
                                          placeOfBirth: data?.birthPlace,
                                          cityOfBirth: data?.city?.name,
                                          citizenship: data?.nationality?.name,
                                          idCardKtp: data?.cardId,
                                          address: "\(data?.city?.name ?? "") \(data?.district?.name ?? "") \(data?.subDistrict?.name ?? "") \(data?.street ?? "") RT/RW :\(data?.rtRw ?? "")",
                                          extPatientId: data?.externalPatientId)
            return .success(model)
        }
        //MARK: - FIXME
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestDelete(body: DeleteMemberBody) -> Single<Bool> {
            return Single.create { (observer) in
                self.deleteMemberAPI
                    .request(body: body)
                    .catch { (error) -> PrimitiveSequence<SingleTrait, DeleteMemberResponse> in
                        if (error as? HTTPError) == HTTPError.expired {
                            return self
                                .deleteMemberAPI
                                .httpClient
                                .verify()
                                .andThen(self.deleteMemberAPI.request(body: body))
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
    
        private func outputTransformModel(_ response: DeleteMemberResponse) -> Result<Bool, HTTPError> {
            //MARK: - FIXME
            if response.status ?? false{
                return .success(true)
            }
    
            return .failure(HTTPError.custom(response.message ?? ""))
        }
    

}
