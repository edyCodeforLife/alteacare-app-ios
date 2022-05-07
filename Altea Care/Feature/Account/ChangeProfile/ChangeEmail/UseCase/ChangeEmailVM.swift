//
//  ChangeEmailVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 21/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class ChangeEmailVM : BaseViewModel {
    
    private let repository : ChangeEmailRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let changeEmailAddressRelay = BehaviorRelay<ChangeEmailModel?>(value: nil)
    
    struct Input {
        let changeEmailAddressInput : Observable<RequestChangeEmailBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let changeEmailAddressOutput: Driver<ChangeEmailModel?>
    }
    
    init(repository : ChangeEmailRepository) {
        self.repository = repository
    }
    
    func makeChangeEmailAddress(_ input : Input) {
        input
            .changeEmailAddressInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestChangeEmailAddess(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
            }).disposed(by: self.disposeBag)
    }
    
    func requestChangeEmailAddess(body : RequestChangeEmailBody){
        self.repository
            .requestChangeEmail(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.success("Berhasil Send OTP ke Email"))
                self.changeEmailAddressRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeChangeEmailAddress(input)
        return Output(state: self.stateRelay.asDriver().skip(1), changeEmailAddressOutput: self.changeEmailAddressRelay.asDriver().skip(1))
    }
}
