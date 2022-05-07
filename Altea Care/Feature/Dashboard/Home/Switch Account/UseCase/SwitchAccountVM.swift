//
//  SwitchAccountVM.swift
//  Altea Care
//
//  Created by Tiara on 09/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class SwitchAccountVM: BaseViewModel {
    
    private let repository: SwitchAccountRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    struct Input {
        
    }
    
    struct Output {
        let state: Driver<BasicUIState>
    }
    
    init(repository: SwitchAccountRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        return Output(state: self.stateRelay.asDriver().skip(1))
    }
    
    
}
