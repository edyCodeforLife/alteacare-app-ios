//
//  SearchAutocompleteRepositoryImpl.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 04/07/21.
//

import Foundation
import RxSwift

class SearchAutocompleteRepositoryImpl: SearchAutocompleteRepository {
    private let searchEverythingApi: SearchAPI
    private let disposeBag = DisposeBag()
    
    init(api: SearchAPI) {
        self.searchEverythingApi = api
    }
    
    func requestEverything(q: String) -> Single<([SearchEverythingsModel],MetaSearchModel)> {
        return Single.create { (observer) in
            self.searchEverythingApi.requestEverything(q: q)
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, SearchResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .searchEverythingApi
                            .httpClient
                            .verify()
                            .andThen(self.searchEverythingApi.requestEverything(q: q))
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
    
    private func outputTransformModel(_ response: SearchResponse) -> Result<([SearchEverythingsModel], MetaSearchModel), HTTPError> {
        if response.status {
            var model : [SearchAutocompleteModel] = []
            var modelDoctor : [SearchAutocompleteModel] = []
            var modelSpecialization : [SearchAutocompleteModel] = []
            var modelSymtom : [SearchAutocompleteModel] = []
            var modelEverything : [SearchEverythingsModel] = []
            let dataDoctor = response.data.doctor
            let dataSpecialization = response.data.specialization
            let dataSymtom = response.data.symtom
            let meta = MetaSearchModel(
                totalDoctort: response.meta.totalDoctor,
                totalSymptom: response.meta.totalSymtom,
                totalSpecialization: response.meta.totalSpecialization)
            
            if !dataSymtom.isEmpty {
                for indexSymtom in 0..<dataSymtom.count {
                    let data = SearchAutocompleteModel(
                        type: .symtom,
                        id: dataSymtom[indexSymtom].symtomId,
                        name: dataSymtom[indexSymtom].name,
                        photo: "",
                        experience: "",
                        specialization: "")
                    model.append(data)
                    modelSymtom.append(data)
                }
                let data = SearchEverythingsModel(searchType: .symtom, data: modelSymtom)
                modelEverything.append(data)
            }
            
            if !dataSpecialization.isEmpty {
                for indexSpecialization in 0..<dataSpecialization.count {
                    let data = SearchAutocompleteModel(
                        type: .specialization,
                        id: dataSpecialization[indexSpecialization].specializationId,
                        name: dataSpecialization[indexSpecialization].name,
                        photo: "",
                        experience: "",
                        specialization: "")
                    model.append(data)
                    modelSpecialization.append(data)
                }
                let data = SearchEverythingsModel(searchType: .specialization, data: modelSpecialization)
                modelEverything.append(data)
            }
            
            if !dataDoctor.isEmpty {
                for indexDoctor in 0..<dataDoctor.count {
                    let data = SearchAutocompleteModel(
                        type: .doctor,
                        id: dataDoctor[indexDoctor].doctorId,
                        name: dataDoctor[indexDoctor].name,
                        photo: dataDoctor[indexDoctor].photo?.formats.small,
                        experience: dataDoctor[indexDoctor].experience,
                        specialization: dataDoctor[indexDoctor].specialization?.name)
                    model.append(data)
                    modelDoctor.append(data)
                }
                
                let data = SearchEverythingsModel(searchType: .doctor, data: modelDoctor)
                modelEverything.append(data)
            }
            
            return .success((modelEverything, meta))
        }
        return .failure(HTTPError.custom(response.message))
    }
}

