//
//  ReverificationEmailVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ReverificationEmailVM: BaseViewModel {
    private let repository : ReverificationEmailRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value : .loading)
    private let verifyOtpRelay = BehaviorRelay<ReverificationEmailModel?>(value: nil)
    private let requestNewOtpRelay = BehaviorRelay<ForgotPasswordModel?>(value: nil)
    
    struct Input {
        let verifyOtpInput : Observable<VerifyOTPForgotPasswordBody?>
        let requestNewOtpInput : Observable<RequestForgotPasswordBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let verifyOtpOutput : Driver<ReverificationEmailModel?>
        let requestNewOtpOutput : Driver<ForgotPasswordModel?>
    }
    
    init(repository : ReverificationEmailRepository) {
        self.repository = repository
    }
    
    private func makeVerifyOtp(_ input : Input){
        input
            .verifyOtpInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestVerifyOtp(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    private func requestVerifyOtp(body : VerifyOTPForgotPasswordBody){
        self.repository
            .requestVerifyForgotPassword(body: body)
            .subscribe { (result) in
                self.requestVerifyOtp(body: body)
                self.verifyOtpRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestNewOtp(_ input : Input){
        input
            .requestNewOtpInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestNewOtp(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    private func requestNewOtp(body : RequestForgotPasswordBody){
        self.repository
            .requestNewOtpChangePassword(body: body)
            .subscribe{ (result) in
                self.stateRelay.accept(.close)
                self.requestNewOtpRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeVerifyOtp(input)
        self.makeRequestNewOtp(input)
        return Output(state: self.stateRelay.asDriver().skip(1), verifyOtpOutput: self.verifyOtpRelay.asDriver().skip(1), requestNewOtpOutput: self.requestNewOtpRelay.asDriver().skip(1))
    }
}
