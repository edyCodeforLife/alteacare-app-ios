//
//  ForgotPasswordVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ForgotPasswordVM: BaseViewModel {
    
    private let repository : ForgotPasswordRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value : .loading)
    private let forgotPasswordRelay = BehaviorRelay<ForgotPasswordModel?>(value: nil)
    
    struct Input {
        let forgotPasswordInput : Observable<RequestForgotPasswordBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let forgotPasswordOutput : Driver<ForgotPasswordModel?>
    }
    
    init(repository : ForgotPasswordRepository) {
        self.repository = repository
    }
    
    func makeRequestForgotPassword(_ input : Input){
        input
            .forgotPasswordInput
            .compactMap { ($0) }
            .subscribe(onNext: { (body) in
                self.requestForgotPassword(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func requestForgotPassword(body : RequestForgotPasswordBody){
        self.repository.requestForgotPassword(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.success(result.message))
                self.forgotPasswordRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestForgotPassword(input)
        return Output(state: self.stateRelay.asDriver().skip(1), forgotPasswordOutput: self.forgotPasswordRelay.asDriver().skip(1))
    }
}
