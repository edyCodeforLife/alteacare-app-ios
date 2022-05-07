//
//  ListMemberRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

class ListMemberRepositoryImpl: ListMemberRepository {
    
    private let listMemberAPI: ListMemberAPI
    private let deleteMemberAPI: DeleteMemberAPI
    private let defaultMemberAPI: DefaultMemberAPI
    private let disposeBag = DisposeBag()
    
    init(listMemberAPI: ListMemberAPI, deleteMemberAPI: DeleteMemberAPI,defaultMemberAPI: DefaultMemberAPI) {
        self.listMemberAPI = listMemberAPI
        self.deleteMemberAPI = deleteMemberAPI
        self.defaultMemberAPI = defaultMemberAPI
    }
    
    func requestList() -> Single<ListMemberModel> {
        return Single.create { (observer) in
            self.listMemberAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, ListMemberResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .listMemberAPI
                            .httpClient
                            .verify()
                            .andThen(self.listMemberAPI.request())
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
    
    private func outputTransformModel(_ response: ListMemberResponse) -> Result<ListMemberModel, HTTPError> {
        //MARK: - FIXME
        if response.status ?? false {
            let modelMember = response.data?.patient.map { (res) in
                return MemberModel(idMember: res.id ?? "",
                                   name: "\(res.firstName ?? "") \(res.lastName ?? "")",
                                   role: res.familyRelationType?.name ?? "",
                                   imageUser: res.cardPhoto?.formats?.medium ?? "",
                                   age: "\(res.age?.year ?? 0) Tahun \(res.age?.month ?? 0) Bulan" ,
                                   gender: res.gender ?? "",
                                   birthDate: res.birthDate ?? "",
                                   isMainProfile: res.isDefault ?? false,
                                   email : res.email,
                                   phone : res.phone
                )
                
            }
            let model = ListMemberModel(isFullyLoaded: false, model: modelMember)
            
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
    
    func requestDefaultMember(body: SetDefaultMemberBody) -> Single<Bool> {
        return Single.create { (observer) in
            self.defaultMemberAPI
                .requestSetAsDefault(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, SetDefaultMemberResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .defaultMemberAPI
                            .httpClient
                            .verify()
                            .andThen(self.defaultMemberAPI.requestSetAsDefault(body: body))
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

    private func outputTransformModel(_ response: SetDefaultMemberResponse) -> Result<Bool, HTTPError> {
        //MARK: - FIXME
        if response.status {
            return .success(true)
        }
        return .failure(HTTPError.custom(response.message ))
    }
}
