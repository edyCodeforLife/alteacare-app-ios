//
//  ContactUsVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class ContactUsVM : BaseViewModel {
    
    private let repository: ContactUsRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let getMessageTypeRelay = BehaviorRelay<MessageTypeModel?>(value: nil)
    private let getIformationCenterRelay = BehaviorRelay<InformationCenterModel?>(value: nil)
    
    private let sendMessageRelay =  BehaviorRelay<ContactUsModel?>(value: nil)
    
    struct Input {
        let viewDidLoadRelay : Observable<Void>
        let sendMessageInput : Observable<SendMessageBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let getMessageTypeOutput : Driver<MessageTypeModel?>
        let getInformationCenterOutput : Driver<InformationCenterModel?>
        let sendMessageOutput : Driver<ContactUsModel?>
    }
    
    init(repository : ContactUsRepository) {
        self.repository = repository
    }
    
    private func makeRequestSendMessage(_ input : Input){
        input
            .sendMessageInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestSendMessage(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func requestSendMessage(body : SendMessageBody){
        self.repository
            .requestSendMessage(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.sendMessageRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestGetMessageType(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestGetMessageType()
            }.disposed(by: self.disposeBag)
    }
    
    func requestGetMessageType(){
        self.repository
            .requestSendType()
            .subscribe(onSuccess: { (result) in
                self.stateRelay.accept(.close)
                self.getMessageTypeRelay.accept(result)
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    private func makeRequestInformationCenter(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestInformationCenter()
            }.disposed(by: self.disposeBag)
    }
    
    func requestInformationCenter(){
        self.repository
            .requestInformationCenter()
            .subscribe(onSuccess: { (result) in
                self.stateRelay.accept(.close)
                self.getIformationCenterRelay.accept(result)
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestGetMessageType(input)
        self.makeRequestInformationCenter(input)
        self.makeRequestSendMessage(input)
        return Output(state: self.stateRelay.asDriver().skip(1), getMessageTypeOutput: self.getMessageTypeRelay.asDriver().skip(1), getInformationCenterOutput: self.getIformationCenterRelay.asDriver().skip(1), sendMessageOutput: self.sendMessageRelay.asDriver().skip(1))
    }
    
}
