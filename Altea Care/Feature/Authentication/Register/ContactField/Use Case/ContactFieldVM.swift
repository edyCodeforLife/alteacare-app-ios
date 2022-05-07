//
//  ContactFieldVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ContactFieldVM: BaseViewModel {
    
    private let repository: ContactFieldRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let requestCheckEmailRegisterRelay = BehaviorRelay<CheckEmailRegisterModel?>(value: nil)
    
    struct Input {
        let checkEmailRegisterInput : Observable<CheckEmailRegisterBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let checkEmailRegisterOutput : Driver<CheckEmailRegisterModel?>
    }
    
    init(repository: ContactFieldRepository) {
        self.repository = repository
    }
    
    private func makeRequestCheckEmailRegister(_ input: Input){
        input
            .checkEmailRegisterInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestCheckEmailRegister(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    private func requestCheckEmailRegister(body: CheckEmailRegisterBody){
        self.repository
            .requestCheckEmailRegister(body: body)
            .subscribe(onSuccess: { (result) in
                self.stateRelay.accept(.close)
                self.requestCheckEmailRegisterRelay.accept(result)
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestCheckEmailRegister(input)
        return Output(state: self.stateRelay.asDriver().skip(1), checkEmailRegisterOutput: self.requestCheckEmailRegisterRelay.asDriver().skip(1))
    }
}
