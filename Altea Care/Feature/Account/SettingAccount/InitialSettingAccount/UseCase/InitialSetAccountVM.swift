//
//  InitialSetAccountVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 05/04/21.
//

import Foundation
import RxSwift
import RxCocoa

class InitialSetAccountVM: BaseViewModel {
    
    private let repository: InitialSetAccountRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    struct Input {
        
    }
    
    struct Output {
        let state: Driver<BasicUIState>
    }
    
    init(repository: InitialSetAccountRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        return Output(state: self.stateRelay.asDriver().skip(1))
    }
    
}
