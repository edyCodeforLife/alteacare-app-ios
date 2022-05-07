//
//  FilterDoctorVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//
import RxCocoa
import RxSwift
import Foundation


class FilterDoctorVM: BaseViewModel {
    
    // MARK: - BASE PROPERTY
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    init() {
        
    }

    struct Input {
    }
    
    struct Output {
        let state: Driver<BasicUIState>
    }
    
    // MARK: - QA TEST FUNCTION
    
    
    // MARK: - START FUNCTION
    func transform(_ input: Input) -> Output {
        return Output(
            state: self.stateRelay.asDriver().skip(1))
    }
    
    

}
