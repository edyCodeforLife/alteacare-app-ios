//
//  ChangePasswordVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ChangePasswordVM: BaseViewModel {
    
    private let repository: ChangePasswordRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let changePasswordRelay = BehaviorRelay<ChangePasswordModel?>(value: nil)
    
    struct Input {
        let changePasswordInput : Observable<ChangePasswordBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let changePasswordOutput : Driver<ChangePasswordModel?>
    }
    
    init(repository: ChangePasswordRepository) {
        self.repository = repository
    }
    
    private func makeRequestChangePassword(_ input : Input) {
        input
            .changePasswordInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestChangePassword(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestChangePassword(body : ChangePasswordBody){
        self.repository
            .requestChangePassword(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.success("Berhasil Change Password"))
                self.changePasswordRelay.accept(result)
            } onFailure: {  (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestChangePassword(input)
        return Output(state: self.stateRelay.asDriver().skip(1), changePasswordOutput: self.changePasswordRelay.asDriver().skip(1))
    }
    
}
