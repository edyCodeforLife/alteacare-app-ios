//
//  SettingRepositoryImpl.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 28/11/21.
//

import Foundation
import RxSwift

class SettingRepoasitoryImpl: SettingRepository {
    
    private let disposeBag = DisposeBag()
    private let settingAPI: SettingAPI
    
    init (settingAPI: SettingAPI) {
        self.settingAPI = settingAPI
    }
    
    func getSettingModel() -> Single<SettingModel> {
        return Single.create { (observer) in
            self.settingAPI
                .getSettings()
                .catch { (error) -> PrimitiveSequence<SingleTrait, SettingResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .settingAPI
                            .httpClient
                            .verify()
                            .andThen(self.settingAPI.getSettings())
                    }
                    return Single.error(error)
                }
                .map { self.outputTransormFromModel($0) }
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
    
    private func outputTransormFromModel (_ response: SettingResponse) -> Result<SettingModel, HTTPError> {
        if let data = response.data, response.status {
            return .success(SettingModel(
                operationalHourStart: data.operationalHourStart,
                operationalHourEnd: data.operationalHourEnd
            ))
        }
        return .failure(.custom(response.message))
    }
}
