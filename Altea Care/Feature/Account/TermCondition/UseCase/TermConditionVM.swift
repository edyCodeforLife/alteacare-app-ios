//
//  TermConditionVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 11/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class TermConditionVM : BaseViewModel {
    
    private let repository : TermConditionRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let termConditionRelay = BehaviorRelay<TermConditionModel?>(value: nil)
    
    struct Input {
        let viewDidLoadRelay : Observable<Void>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let termCondition : Driver<TermConditionModel?>
    }
    
    init(repository : TermConditionRepository) {
        self.repository = repository
    }
    
    private func makeTermCondition(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestTermConditionOnAccount()
            }.disposed(by: self.disposeBag)
    }
    
    func requestTermConditionOnAccount(){
        self.repository
            .requestTermConditionAccount()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.termConditionRelay.accept(result)
            } onFailure: { error in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeTermCondition(input)
        return Output(state: self.stateRelay.asDriver().skip(1), termCondition: self.termConditionRelay.asDriver().skip(1))
    }
}
