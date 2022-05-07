//
//  VerifyMemberVM.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class VerifyMemberVM: BaseViewModel {
    
    private let repository: VerifyMemberRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    struct Input {
        
    }
    
    struct Output {
        let state: Driver<BasicUIState>
    }
    
    init(repository: VerifyMemberRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        return Output(state: self.stateRelay.asDriver().skip(1))
    }
    
    
}
