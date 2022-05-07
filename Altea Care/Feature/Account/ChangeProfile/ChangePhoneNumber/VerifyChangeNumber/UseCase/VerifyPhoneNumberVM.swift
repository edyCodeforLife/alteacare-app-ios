//
//  VerifyPhoneNumberVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class VerifyPhoneNumberVM : BaseViewModel {
    
    private let repository : VerifyPhoneNumberRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let changePhoneNumberRelay = BehaviorRelay<VerifyPhoneNumberModel?>(value: nil)
    
    struct Input {
        let changePhoneNumberInput : Observable<ChangePhoneNumberBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let changePhoneNumberOutput: Driver<VerifyPhoneNumberModel?>
    }
    
    init(repository : VerifyPhoneNumberRepository) {
        self.repository = repository
    }
    
    func makeChangePhoneNumber(_ input : Input) {
        input
            .changePhoneNumberInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestChangePhoneNumber(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    func requestChangePhoneNumber(body : ChangePhoneNumberBody){
        self.repository
            .requestVerifyPhoneNumber(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.success("Berhasil Ubah PhoneNumber"))
                self.changePhoneNumberRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeChangePhoneNumber(input)
        return Output(state: self.stateRelay.asDriver().skip(1), changePhoneNumberOutput: self.changePhoneNumberRelay.asDriver().skip(1))
    }
}
