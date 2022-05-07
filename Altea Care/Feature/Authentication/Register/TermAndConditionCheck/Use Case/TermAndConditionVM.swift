//
//  TermAndConditionVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class TermAndConditionVM: BaseViewModel {
    
    private let termConditionRepository : TermAndConditionRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let termConditionRelay = BehaviorRelay<TermAndConditionModel?>(value: nil)
    private let registerRelay = BehaviorRelay<RegisterModel?>(value: nil)
    private let sendVerificationRelay = BehaviorRelay<SendVerificationEmailModel?>(value: nil)
    
    struct Input {
       
        let sendVerificationEmailRequest : Observable<SendVerificationEmailBody?>
        let viewDidLoadRelay : Observable<Void>
        let registerRequest : Observable<RegisterBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let termCondition : Driver<TermAndConditionModel?>
        let registerOutput : Driver<RegisterModel?>
        let sendVerificationToEmail : Driver<SendVerificationEmailModel?>
    }
    
    init(termCondition: TermAndConditionRepository) {
        self.termConditionRepository =  termCondition
    }
    
    func transform(_ input: Input) -> Output {
        self.makeTermCondition(input)
        self.makeSendVerificationEmail(input)
        self.makeRegister(input)
        return Output(state: self.stateRelay.asDriver().skip(1), termCondition: self.termConditionRelay.asDriver().skip(1), registerOutput: self.registerRelay.asDriver().skip(1), sendVerificationToEmail: self.sendVerificationRelay.asDriver().skip(1))
    }
    
    private func makeTermCondition(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestTermCondition()
            }.disposed(by: self.disposeBag)
    }
    
    func requestTermCondition(){
        self.termConditionRepository
            .requestTermCondition()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.termConditionRelay.accept(result)
            } onFailure: { error in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
            
    }
    
    private func makeRegister(_ input : Input) {
        input
            .registerRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestRegister(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }

    func requestRegister(body : RegisterBody) {
        self.termConditionRepository
            .requestRegister(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.registerRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeSendVerificationEmail(_ input : Input){
        input
            .sendVerificationEmailRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestSendVerificationEmail(body: body)
                self.stateRelay.accept(.loading)
            }).disposed(by: self.disposeBag)
    }
    
    func requestSendVerificationEmail(body : SendVerificationEmailBody){
        self.termConditionRepository
            .requestSendVerificationEmail(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.sendVerificationRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
