//
//  SuccessRegisterVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 03/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class SuccessRegisterVM : BaseViewModel {
    
    func transform(_ input: Input) -> Output {
        self.makeGetUser(input)
        return Output(state: self.stateRelay.asDriver().skip(1),
                      model: self.modelRelay.asDriver().skip(1))
    }
    
    private let repository : SuccessRegisterRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let modelRelay = BehaviorRelay<UserHomeData?>(value: nil)
    
    struct Input {
        let didLoadRelay : Observable<Void>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let model : Driver<UserHomeData?>
    }
    
    init(repository : SuccessRegisterRepository) {
        self.repository = repository
    }
    
    private func makeGetUser(_ input: Input) {
        input.didLoadRelay.subscribe { _ in
            self.stateRelay.accept(.loading)
            self.requestGetUser()
        }.disposed(by: self.disposeBag)
    }
    
    private func requestGetUser() {
        self.repository.requestGetUserData().subscribe { data in
            self.stateRelay.accept(.close)
            self.modelRelay.accept(data)
        } onFailure: { error in
            self.stateRelay.accept(.close)
            self.modelRelay.accept(nil)
            print(error.readableError)
        } onDisposed: {
            print("onDisposed")
        }.disposed(by: self.disposeBag)

    }
}
