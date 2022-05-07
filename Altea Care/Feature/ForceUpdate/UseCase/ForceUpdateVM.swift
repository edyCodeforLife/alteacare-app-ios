//
//  ForceUpdateVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 19/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class ForceUpdateVM: BaseViewModel {
    
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let disposeBag = DisposeBag()
    private let repository : ForceUpdateRepository
    private let forceUpdateRelay = BehaviorRelay<ForceUpdateModel?>(value: nil)
    
    struct Input {
        let viewDidLoadRelay: Observable<Void>
    }
    
    init(repository: ForceUpdateRepository) {
        self.repository = repository
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let forceUpdateOutput : Driver<ForceUpdateModel?>
    }
//    
//    private func makeRequestForceUpdate(_ input : Input){
//        input
//            .viewDidLoadRelay
//            .compactMap { $0 }
//            .subscribe { (_) in
//                self.stateRelay.accept(.loading)
//                self.requestForceUpdate()
//            }.disposed(by: self.disposeBag)
//    }
//
//    private func requestForceUpdate(){
//        self.repository
//            .requestForceUpdate()
//            .subscribe(onSuccess: { (result) in
//                self.stateRelay.accept(.close)
//                self.forceUpdateRelay.accept(result)
//            }, onFailure: { (error) in
//                self.stateRelay.accept(.failure(error.readableError))
//            }).disposed(by: self.disposeBag)
//    }
    
    func transform(_ input: Input) -> Output {
        return Output(state: self.stateRelay.asDriver().skip(1), forceUpdateOutput: self.forceUpdateRelay.asDriver().skip(1))
    }
}
