//
//  FilterListHospitalVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class FilterListHospitalVM : BaseViewModel {
    
    private let repository: FilterListHospitalRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let listHospitalRelay = BehaviorRelay<ListHospitalModel?>(value: nil)
    
    struct Input {
        let viewDidLoadRelay : Observable<Void>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let hospitalList: Driver<ListHospitalModel?>
    }
    
    init(repository : FilterListHospitalRepository) {
        self.repository = repository
    }
    
    private func makeRequestListHospital(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestListHospital()
            }.disposed(by: self.disposeBag)
    }
    
    func requestListHospital(){
        self.repository
            .requestListHospital()
            .subscribe{ (result) in
                self.stateRelay.accept(.close)
                self.listHospitalRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.close)
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestListHospital(input)
        return Output(state: self.stateRelay.asDriver(), hospitalList: self.listHospitalRelay.asDriver())
    }
}
