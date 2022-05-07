//
//  SearchAutocompleteVM.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 04/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class SearchAutocompleteVM : BaseViewModel {
    private let repository: SearchAutocompleteRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let searchEverythingRelay = BehaviorRelay<[SearchEverythingsModel?]>(value: [])
    private let metaRelay = BehaviorRelay<MetaSearchModel?>(value:nil)
    
    struct Input {
        let viewDidLoadRelay: Observable<Void>
        let search: Observable<String?>
    }
    
    struct Output{
        let state: Driver<BasicUIState>
        let searchEverything: Driver<[SearchEverythingsModel?]>
        let meta: Driver<MetaSearchModel?>
    }
    
    init(repository: SearchAutocompleteRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeSearchEverything(input)
        return Output(state: self.stateRelay.asDriver().skip(1), searchEverything: self.searchEverythingRelay.asDriver().skip(1), meta: self.metaRelay.asDriver().skip(1))
    }
    
    func makeSearchEverything(_ input: Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.requestSearchEverything(input: input)
            }.disposed(by: self.disposeBag)
    }
    
    func requestSearchEverything(input: Input) {
        input
            .search
            .compactMap {$0}
            .subscribe(onNext: { (result) in
                self.stateRelay.accept(.loading)
                self.repository
                    .requestEverything(q: result)
                    .subscribe { (result) in
                        self.stateRelay.accept(.close)
                        self.metaRelay.accept(result.1)
                        self.searchEverythingRelay.accept(result.0)
                    } onFailure: { (error) in
                        self.stateRelay.accept(.failure(error.readableError))
                    }.disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
        
    }
}
