//
//  ListSpecialistVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ListSpecialistVM: BaseViewModel {
    
    private let repository: ListSpecialistRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let specialistRelay = BehaviorRelay<[ListSpecialistModel]>(value: [])
    
    struct Input {
        let searchQuery: Observable<String?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let specialistList: Driver<[ListSpecialistModel]>
    }
    
    init(repository: ListSpecialistRepository) {
        self.repository = repository
    }
    
    func makeRequestSpecialistList(_ input: Input) {
        input
            .searchQuery
            .compactMap{$0}
            .subscribe(
                onNext: { (query) in
                    self.stateRelay.accept(.loading)
                    self.requestListSpecialist(q: query)
                }
            ).disposed(by: self.disposeBag)
    }
    
    func requestListSpecialist(q: String) { // disini irfan
        self.repository
            .requestSpecializations(q)
            .subscribe{ (result) in
                self.stateRelay.accept(.close)
                self.specialistRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.close)
                //                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestSpecialistList(input)
        return Output(state: self.stateRelay.asDriver().skip(1), specialistList: specialistRelay.asDriver().skip(1))
    }
    
}
