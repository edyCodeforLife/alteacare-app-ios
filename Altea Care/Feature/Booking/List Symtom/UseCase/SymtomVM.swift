//
//  SearchResultVM.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 18/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class SymtomVM {
    private let repository: SymtomRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let searchResults = BehaviorRelay<[SymtomResultModel]>(value: [])
    
    struct Input {
        let search: Observable<String?>
    }
    
    struct Output{
        let state: Driver<BasicUIState>
        let searchResults: Driver<[SymtomResultModel]>
    }
    
    init(repository: SymtomRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input,_ searchType: search) -> Output {
        self.makeSearchEverything(input,searchType)
        return Output(state: self.stateRelay.asDriver().skip(1), searchResults: self.searchResults.asDriver().skip(1))
    }
    
    func makeSearchEverything(_ input: Input,_ searchType: search){
        switch searchType {
        case .symtom:
            self.requestSearchSymptom(input: input)
        case .specialization:
            break
        default: break
        }
    }
    
    
    func requestSearchSymptom(input: Input) {
        input
            .search
            .compactMap {$0}
            .subscribe(onNext: { (result) in
                self.stateRelay.accept(.loading)
                self.repository
                    .searchSymtoms(query: result)
                    .subscribe { (result) in
                        self.stateRelay.accept(.close)
                        self.searchResults.accept(result)
                    } onFailure: { (error) in
                        self.stateRelay.accept(.failure(error.readableError))
                    }.disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
        
    }
}
