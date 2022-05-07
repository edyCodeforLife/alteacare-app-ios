//
//  VerifyChangeEmailVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class VerifyChangeEmailVM: BaseViewModel {
   
    
    private let repository : VerifyChangeEmailRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let verifychangeEmailRelay = BehaviorRelay<VerifyChangeEmailModel?>(value: nil)
    
    
    init(repository : VerifyChangeEmailRepository) {
        self.repository = repository
    }
    
    struct Input{
     let verifychangeEmailInput : Observable<ChangeEmailVerifyBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let verifychangeEmailOutput: Driver<VerifyChangeEmailModel?>
    }
    
    func makeverifyChangeEmailAddress(_ input : Input) {
        input
            .verifychangeEmailInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.verifyChangeEmailAddess(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
            }).disposed(by: self.disposeBag)
    }
    
    func verifyChangeEmailAddess(body : ChangeEmailVerifyBody){
        self.repository.requestVerifyChangeEmail(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.success("Berhasil Ganti Email"))
                self.verifychangeEmailRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeverifyChangeEmailAddress(input)
        return Output(state: self.stateRelay.asDriver().skip(1), verifychangeEmailOutput: self.verifychangeEmailRelay.asDriver().skip(1))
    }
    
}
