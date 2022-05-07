//
//  SearchResultRepositoryImpl.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 18/11/21.
//

import Foundation
import RxSwift

class SymtomRepositoryImpl: SymtomRepository {
    
    private let listSpecialistAPI: ListSpecialistAPI
    private let listSymptomAPI: ListSymptomAPI
    private let disposeBag = DisposeBag()
    
    init(listSpecialistApi: ListSpecialistAPI, listSymptomAPI: ListSymptomAPI) {
        self.listSpecialistAPI = listSpecialistApi
        self.listSymptomAPI = listSymptomAPI
    }
    
    
    func searchSymtoms(query: String) -> Single<[SymtomResultModel]> {
        return Single.create { (observer) in
            self.listSymptomAPI.requestSymptomListSearch(body: ListSymptomBody(querySearch: query, limit: 1000))
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, ListSymptomResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .listSymptomAPI
                            .httpClient
                            .verify()
                            .andThen(self.listSymptomAPI.requestSymptomListSearch(body: ListSymptomBody(querySearch: query, limit: 1000)))
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
    
    private func outputTransformModel(_ response: ListSymptomResponse) -> Result<[SymtomResultModel], HTTPError> {
        if response.status {
            
            let searchResult = response.data.map {
                SymtomResultModel(id: $0.symtomId, title: $0.name)
            }
            return .success(searchResult)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
}
