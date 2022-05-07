//
//  RegisterRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/03/21.
//

import Foundation
import RxSwift

class RegisterRepositoryImpl: RegisterRepository {
    
    private let countryAPI : CountryAPI
    private let disposeBag = DisposeBag()
    
    init(countryAPI : CountryAPI) {
        self.countryAPI = countryAPI
    }
    
    func requestGetCountry() -> Single<CountryModel?> {
        return Single.create { (observer) in
            self.countryAPI
                .request()
                .catch{ (error) -> PrimitiveSequence<SingleTrait, CountryResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .countryAPI
                            .httpClient
                            .verify()
                            .andThen(self.countryAPI.request())
                    }
                    return Single.error(error)
                }
                .map{ self.transformOutputCountryModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) :
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func transformOutputCountryModel(_ response : CountryResponse) -> Result<CountryModel, HTTPError> {
        if response.status {
            let dataCountry = response.data.map { (data) in
                
                return CountryData(countryId: data.countryId, name: data.name)
            }
            
            let model =  CountryModel(status: response.status, message: response.message, data: dataCountry)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
