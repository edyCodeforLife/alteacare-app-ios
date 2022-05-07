//
//  EmailVerificationVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol OtpText {
    var otpText : Observable<String> { get }
}

class EmailVerificationVM: BaseViewModel {
    
    private let repository: EmailVerificationRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let emailVerifyRelay = BehaviorRelay<EmailVerificationModel?>(value: nil)
    private let requestNewOTPRelay = BehaviorRelay<SendVerificationEmailModel?>(value: nil)
    private var type : String = ""
    
    struct Input {
        let sendVerificationEmailRequest : Observable<SendVerificationEmailBody?>
        let sendVerifyEmailRequest : Observable<VerifyEmailBody?>
        let type : Observable<String>
        
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let verifyOTPOutput : Driver<EmailVerificationModel?>
        let requestNewOTPOutput : Driver<SendVerificationEmailModel?>
    }
    
    init(repository: EmailVerificationRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        makeVerifyEmail(input)
        makeNewRequestOTP(input)
        updateType(input)
        return Output(state: self.stateRelay.asDriver().skip(1), verifyOTPOutput: self.emailVerifyRelay.asDriver().skip(1), requestNewOTPOutput: self.requestNewOTPRelay.asDriver().skip(1))
    }
    
    private func updateType(_ input : Input){
        input
            .type
            .compactMap { $0 }
            .subscribe(onNext: { (t) in
                self.type = t
            }, onError: { (error) in
            }).disposed(by: self.disposeBag)
    }
    
    private func makeVerifyEmail(_ input : Input){
        input
            .sendVerifyEmailRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestVerifyEmail(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func requestVerifyEmail(body : VerifyEmailBody) {
        self.repository
            .requestVerifyEmail(body: body, type: type)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.emailVerifyRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeNewRequestOTP(_ input : Input) {
        input
            .sendVerificationEmailRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestNewOTP(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func requestNewOTP(body : SendVerificationEmailBody){
        self.repository
            .requestNewOtp(body: body, type: type)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.requestNewOTPRelay.accept(result)
            } onFailure: { error in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
