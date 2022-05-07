//
//  FilterListHospitalRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//

import Foundation
import RxSwift

class FilterListHospitalRepositoryImpl : FilterListHospitalRepository {
    
    
    
    private let disposeBag = DisposeBag()
    private let listHospitalAPI : ListHospitalAPI
    
    init(listHospitalAPI: ListHospitalAPI){
        self.listHospitalAPI = listHospitalAPI
    }
    
    func requestHospitals() -> Single<[ListHospitalModel]> {
        return Single.create { (observer) in
            self.listHospitalAPI
                .requestListHospital()
                .catch { (error) -> PrimitiveSequence<SingleTrait, ListHospitalResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .listHospitalAPI
                            .httpClient
                            .verify()
                            .andThen(self.listHospitalAPI.requestListHospital())
                    }
                    return Single.error(error)
                }
                .map { self.transformOutputHospitals($0) }
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
    
    func requestListHospital() -> Single<ListHospitalModel> {
        return Single.create { (observer) in
            self.listHospitalAPI
                .requestListHospital()
                .catch { (error) -> PrimitiveSequence<SingleTrait, ListHospitalResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .listHospitalAPI
                            .httpClient
                            .verify()
                            .andThen(self.listHospitalAPI.requestListHospital())
                    }
                    return Single.error(error)
                }
                .map { self.transformOutputHospitalDataToModel($0) }
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
    
    
    private func transformOutputHospitals(_ response : ListHospitalResponse) -> Result<[ListHospitalModel], HTTPError>{
        if response.status {
            let model = response.data.map { (res) in
                
                return ListHospitalModel(
                    hospitalId: res.hospitalId,
                    name: res.name,
                    phone: res.phone ?? "",
                    address: res.address ?? "",
                    latitude: res.latitude ?? "",
                    longitude: res.longitude ?? "",
                    image:
                        ImageTerms(
                            sizeFormatted: res.image?.sizeFormatted ?? "",
                            mimeType: "image/jpeg",
                            url: res.image?.url ?? "",
                            formats:
                                FormatsTerms(
                                    thumbnail: res.image?.formats.thumbnail ?? "",
                                    large: res.image?.formats.large ?? "",
                                    medium: res.image?.formats.medium ?? "",
                                    small: res.image?.formats.small ?? "")),
                    icon:
                        ImageTerms(
                            sizeFormatted: res.image?.sizeFormatted ?? "",
                            mimeType: "image/jpeg",
                            url: res.image?.url ?? "",
                            formats:
                                FormatsTerms(
                                    thumbnail: res.image?.formats.thumbnail ?? "",
                                    large: res.image?.formats.large ?? "",
                                    medium: res.image?.formats.medium ?? "",
                                    small: res.image?.formats.small ?? "")),
                    externalProvider:
                        ExternalProviderTerms(
                            id: res.externalProvider.id,
                            name: res.externalProvider.name,
                            code: res.externalProvider.code))
            }
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    private func transformOutputHospitalDataToModel(_ response : ListHospitalResponse) -> Result<ListHospitalModel, HTTPError>{
        if response.status {
//            let model = response.data.map { (res) in
//
//                return ListHospitalModel(
//                    hospitalId: res.hospitalId,
//                    name: res.name,
//                    phone: res.phone,
//                    address: res.address,
//                    latitude: res.latitude,
//                    longitude: res.longitude,
//                    image:
//                        ImageTerms(
//                            sizeFormatted: res.image?.sizeFormatted ?? "",
//                            mimeType: "image/jpeg",
//                            url: res.image?.url ?? "",
//                            formats:
//                                FormatsTerms(
//                                    thumbnail: res.image?.formats.thumbnail ?? "",
//                                    large: res.image?.formats.large ?? "",
//                                    medium: res.image?.formats.medium ?? "",
//                                    small: res.image?.formats.small ?? "")),
//                    icon:
//                        ImageTerms(
//                            sizeFormatted: res.image?.sizeFormatted ?? "",
//                            mimeType: "image/jpeg",
//                            url: res.image?.url ?? "",
//                            formats:
//                                FormatsTerms(
//                                    thumbnail: res.image?.formats.thumbnail ?? "",
//                                    large: res.image?.formats.large ?? "",
//                                    medium: res.image?.formats.medium ?? "",
//                                    small: res.image?.formats.small ?? "")),
//                    externalProvider:
//                        ExternalProviderTerms(
//                            id: res.externalProvider.id,
//                            name: res.externalProvider.name,
//                            code: res.externalProvider.code))
//            }
//            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
