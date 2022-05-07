//
//  RegisterReviewVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterReviewVM: BaseViewModel {
    
    private let repository : RegisterReviewRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    struct Input {
        
    }
    
    struct Output {
        let state : Driver<BasicUIState>
    }
    
    init(repository : RegisterReviewRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        return Output(state: self.stateRelay.asDriver().skip(1))
    }
}
