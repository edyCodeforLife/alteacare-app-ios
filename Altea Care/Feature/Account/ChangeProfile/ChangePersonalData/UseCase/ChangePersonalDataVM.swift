//
//  ChangePersonalDataVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 11/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class ChangePersonalDataVM : BaseViewModel {
    
    private let repository : ChangePersonalRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    struct Input {
        
    }
    
    struct Output {
        let state : Driver<BasicUIState>
    }
    
    init(repository : ChangePersonalRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        return Output(state: stateRelay.asDriver().skip(1))
    }
}
