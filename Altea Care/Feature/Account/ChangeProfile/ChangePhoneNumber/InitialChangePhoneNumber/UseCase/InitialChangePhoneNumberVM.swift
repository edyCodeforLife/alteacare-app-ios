//
//  InitialChangePhoneNumberVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class InitialChangePhoneNumberVM : BaseViewModel {
    
    private let repository : InitialChangePhoneNumberRepository
    private let disposeBag = DisposeBag()
    private let stateRelay =  BehaviorRelay<BasicUIState>(value: .loading)
    private let changePhoneNumberRelay = BehaviorRelay<InitialChangePhoneNumberModel?>(value: nil)
    
    struct Input {
        let changePasswordInput : Observable<RequestChangePhoneNumberBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let changePhoneNumberOutput : Driver<InitialChangePhoneNumberModel?>
    }
    
    init(repository : InitialChangePhoneNumberRepository) {
        self.repository = repository
    }
    
    private func makeRequestSendPhoneNumber(_ input : Input){
        input
            .changePasswordInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestSendPhoneNumber(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func requestSendPhoneNumber(body : RequestChangePhoneNumberBody){
        self.repository
            .requestSendPhoneNumber(body: body)
            .subscribe(onSuccess: { (model) in
                self.changePhoneNumberRelay.accept(model)
                self.stateRelay.accept(.success("Request Berhasil"))
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestSendPhoneNumber(input)
        return Output(state: self.stateRelay.asDriver().skip(1), changePhoneNumberOutput: self.changePhoneNumberRelay.asDriver().skip(1))
    }
}
