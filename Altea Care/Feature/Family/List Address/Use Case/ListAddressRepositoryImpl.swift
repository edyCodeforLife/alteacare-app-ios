//
//  ListAddressRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

class ListAddressRepositoryImpl: ListAddressRepository {
    
    private let listAddressAPI: ListAddressAPI
    private let deleteAddressAPI: DeleteAddressAPI
    private let primaryAddressAPI: PrimaryAddressAPI
    private let disposeBag = DisposeBag()
    
    init(listAddressAPI: ListAddressAPI, deleteAddressAPI: DeleteAddressAPI, primaryAddressAPI: PrimaryAddressAPI) {
        self.listAddressAPI = listAddressAPI
        self.deleteAddressAPI = deleteAddressAPI
        self.primaryAddressAPI = primaryAddressAPI
    }
    
    func requestList() -> Single<ListAddressModel> {
        return Single.create { (observer) in
            self.listAddressAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, ListAddressResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .listAddressAPI
                            .httpClient
                            .verify()
                            .andThen(self.listAddressAPI.request())
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
    
    private func outputTransformModel(_ response: ListAddressResponse) -> Result<ListAddressModel, HTTPError> {
        //MARK: - FIXME
        if response.status ?? false{
            let modelAddress = response.data?.address.map { (res) in
                return DetailAddressModel(id: res.id ?? "",
                                          type: res.type ?? "",
                                          street: res.street ?? "",
                                          rtRw: res.rtRw ?? "", country: res.country?.name ?? "", province: res.province?.name ?? "", city: res.city?.name ?? "", district: res.district?.name ?? "", subDistrict: res.subDistrict?.name ?? "", latitude: res.latitude ?? "", longitude: res.longitude ?? "", idCity: res.city?.id ?? "", idProvince: res.province?.id ?? "", idDistrict: res.district?.id ?? "", idCountry: res.country?.id ?? "", idSubDistrict: res.subDistrict?.id ?? "")
            }
            let model = ListAddressModel(status: response.status ?? false, message: response.message ?? "", data: modelAddress)
            
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
    
    func requestDelete(body: DeleteAddressBody) -> Single<Bool> {
        return Single.create { (observer) in
            self.deleteAddressAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DeleteAddressResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .deleteAddressAPI
                            .httpClient
                            .verify()
                            .andThen(self.deleteAddressAPI.request(body: body))
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
    
    private func outputTransformModel(_ response: DeleteAddressResponse) -> Result<Bool, HTTPError> {
        //MARK: - FIXME
        if response.status ?? false{
            return .success(true)
        }
        return .failure(HTTPError.custom(""))
    }
    
    func requestPrimary(body: PrimaryAddressBody) -> Single<String> {
        return Single.create { (observer) in
            self.primaryAddressAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, PrimaryAddressResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .primaryAddressAPI
                            .httpClient
                            .verify()
                            .andThen(self.primaryAddressAPI.request(body: body))
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
    
    private func outputTransformModel(_ response: PrimaryAddressResponse) -> Result<String, HTTPError> {
        //MARK: - FIXME
        if let status = response.status, status {
            return .success(response.message ?? "")
        } else {
            return .failure(HTTPError.custom(response.message ?? ""))
        }
    }
}
