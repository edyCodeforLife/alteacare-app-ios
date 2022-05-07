//
//  LoginVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class LoginVM: BaseViewModel {
    
    private let repository: LoginRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let sendVerificationRelay = BehaviorRelay<SendVerificationEmailModel?>(value: nil)
    
    private let loginRelay = BehaviorRelay<LoginModel?>(value: nil)
    
    struct Input {
        let loginRequest : Observable<LoginBody?>
        let sendVerificationEmailRequest : Observable<SendVerificationEmailBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let loginOutput : Driver<LoginModel?>
        let sendVerificationToEmail : Driver<SendVerificationEmailModel?>
    }
    
    init(repository: LoginRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeLogin(input)
        self.makeSendVerificationEmail(input)
        return Output(state: self.stateRelay.asDriver().skip(1), loginOutput: self.loginRelay.asDriver().skip(1), sendVerificationToEmail: self.sendVerificationRelay.asDriver().skip(1))
    }
    
    private func makeLogin(_ input : Input) {
        input
            .loginRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestLogin(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestLogin(body: LoginBody){
        self.repository
            .requestLogin(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.success("berhasil login"))
                self.loginRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeSendVerificationEmail(_ input : Input){
        input
            .sendVerificationEmailRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestSendVerificationEmail(body: body, type: body.email == nil ? "phone" : "email")
                self.stateRelay.accept(.loading)
            }).disposed(by: self.disposeBag)
    }
    
    func requestSendVerificationEmail(body : SendVerificationEmailBody, type: String){
        self.repository
            .requestSendVerificationEmail(body: body, type: type)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.sendVerificationRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
