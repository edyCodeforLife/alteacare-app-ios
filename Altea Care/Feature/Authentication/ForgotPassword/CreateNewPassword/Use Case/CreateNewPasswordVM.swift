//
//  CreateNewPasswordVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class CreateNewPasswordVM: BaseViewModel {
    private let repository : CreateNewPasswordRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value : .loading)
    private let createNewPasswordRelay = BehaviorRelay<CreateNewPasswordModel?>(value: nil)
    
    struct Input {
        let createNewPasswordInput : Observable<ChangePasswordBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let createNewPasswordOutput : Driver<CreateNewPasswordModel?>
    }
    
    init(repository : CreateNewPasswordRepository) {
        self.repository = repository
    }
    
    func makeRequestCreateNewPassword(_ input : Input){
        input
            .createNewPasswordInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestCreateNewPassword(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func requestCreateNewPassword(body : ChangePasswordBody){
        self.repository
            .requestCreateNewPassword(body: body)
            .subscribe{ (result) in
                self.stateRelay.accept(.close)
                self.createNewPasswordRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestCreateNewPassword(input)
        return Output(state: self.stateRelay.asDriver().skip(1), createNewPasswordOutput: self.createNewPasswordRelay.asDriver().skip(1))
    }
}
