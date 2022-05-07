//
//  FilterListSpesialistVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//

import Foundation
import RxSwift
import RxCocoa


class FilterListSpecialistVM: BaseViewModel {
    
    private let repository: ListSpecialistRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let specialistRelay = BehaviorRelay<[ListSpecialistModel]>(value: [])
    
    struct Input {
        let viewDidLoadRelay: Observable<Void>
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
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestListSpecialist()
            }.disposed(by: self.disposeBag)
    }
    
    func requestListSpecialist() {
        self.repository
            .requestSpecializations("")
            .subscribe{ (result) in
                self.stateRelay.accept(.close)
                self.specialistRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestSpecialistList(input)
        return Output(state: self.stateRelay.asDriver().skip(1), specialistList: specialistRelay.asDriver().skip(1))
    }
    
}
