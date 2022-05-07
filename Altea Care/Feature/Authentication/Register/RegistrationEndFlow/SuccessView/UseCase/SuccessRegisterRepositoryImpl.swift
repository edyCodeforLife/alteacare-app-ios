//
//  SuccessRegisterRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/07/21.
//

import Foundation
import RxSwift

class SuccessRegisterRepositoryImpl : SuccessRegisterRepository {
    
    private let getUserDataApi : GetUserAPI
    private let disposeBag = DisposeBag()
    
    init(getUserAPI : GetUserAPI) {
        self.getUserDataApi = getUserAPI
    }
 
    func requestGetUserData() -> Single<UserHomeData> {
        return Single.create { (observer) in
                self.getUserDataApi
                    .request()
                    .catch { (error) -> PrimitiveSequence<SingleTrait, GetUserResponse> in
                        if (error as? HTTPError) == HTTPError.expired {
                            return self
                                .getUserDataApi
                                .httpClient
                                .verify()
                                .andThen(self.getUserDataApi.request())
                        }
                        return Single.error(error)
                    }
                    .map { self.outputTransformUserDataToModel($0) }
                    .subscribe(onSuccess: { (result) in
                        switch result {
                        case .success(let model) : observer(.success(model))
                        case .failure(let error) : observer(.failure(error))
                        }
                    }, onFailure: { (error) in
                        observer(.failure(error))
                    }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func outputTransformUserDataToModel(_ response : GetUserResponse) -> Result<UserHomeData, HTTPError> {
        if response.status {
            if let data = response.data {
                let userData = UserHomeData(id: response.data?.id ?? "", userPhoto: data.userDetails?.avatar?.formats?.medium ?? "", ageYear: data.userDetails?.age?.year ?? 0, ageMonth: data.userDetails?.age?.month ?? 0, nameUser: "\(data.firstName ?? "") \(data.lastName ?? "")", email: data.email ?? "", dateOfBirth: data.userDetails?.birthDate ?? "", gender: data.userDetails?.gender ?? "", phone: data.phone ?? "", city: data.userAddresses?.first?.city?.name ?? "")
                
                return .success(userData)
            }
        }
        return .failure(HTTPError.custom(response.message))
    }
}
