//
//  ListSpecialistRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class ListSpecialistRepositoryImpl: ListSpecialistRepository {
    
    private let specialistListApi: ListSpecialistAPI
    private let disposeBag = DisposeBag()
    
    init(api: ListSpecialistAPI) {
        self.specialistListApi = api
    }
    
    func requestSpecializations(_ req: SpecializationsRequest) -> Single<[ListSpecialistModel]> {
        return Single.create { (observer) in
            self.specialistListApi.requestSpecializations(req)
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, ListSpecialistResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .specialistListApi
                            .httpClient
                            .verify()
                            .andThen(self.specialistListApi.requestSpecializations(req))
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
                    },
                    onFailure: { (error) in
                        observer(.failure(error))
                        
                    },
                    onDisposed: {}
                )
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
            
        }
    }
    
    func requestSpecializations(_ q: String) -> Single<[ListSpecialistModel]> {
        return Single.create { (observer) in
            self.specialistListApi.requestSpecialistList(q)
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, ListSpecialistResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .specialistListApi
                            .httpClient
                            .verify()
                            .andThen(self.specialistListApi.requestSpecialistList(q))
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
                    },
                    onFailure: { (error) in
                        observer(.failure(error))
                        
                    },
                    onDisposed: {}
                )
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
            
        }
    }
    
    private func outputTransformModel(_ response: ListSpecialistResponse) -> Result<[ListSpecialistModel], HTTPError> {
        if response.status {
            
            var listOfSpecialist = [ListSpecialistModel]()
            
            for specialist in response.data {
                
                let subSpecialist = specialist.subSpecialization?.map { res in
                    return ListSpecialistModel(specializationId: res.specializationId, name: res.name, description: res.description, isPopular: res.isPopular, iconSmall: res.icon?.formats?.small ?? "", subSpecialization: nil)
                }
                let specialistModel = ListSpecialistModel(specializationId: specialist.specializationId, name: specialist.name, description: specialist.description, isPopular: specialist.isPopular, iconSmall: specialist.icon?.formats?.small ?? "", subSpecialization: subSpecialist)
                listOfSpecialist.append(specialistModel)
            }
            
            return .success(listOfSpecialist)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
}
