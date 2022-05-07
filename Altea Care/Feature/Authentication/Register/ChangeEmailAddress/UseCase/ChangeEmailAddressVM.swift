//
//  ChangeEmailAddressVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ChangeEmailAddressVM: BaseViewModel {
    private let repository : ChangeEmailAddressRepository
    private let disposeBag =  DisposeBag()
    private let stateRelay =  BehaviorRelay<BasicUIState>(value: .loading)
    private let changeEmailRelay = BehaviorRelay<ChangeEmailAddressModel?>(value: nil)

    
    struct Input {
        let changeEmailRequest : Observable<RegistrationChangeEmailBody?>
    }
    

    struct Output {
        let state: Driver<BasicUIState>
        let changeEmailOutput : Driver<ChangeEmailAddressModel?>

    }
    
    init(repository: ChangeEmailAddressRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        makeChangeEmail(input)
        return Output(state: self.stateRelay.asDriver().skip(1), changeEmailOutput: self.changeEmailRelay.asDriver().skip(1))
    }
    
    private func makeChangeEmail(_ input : Input) {
        input
            .changeEmailRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestChangeEmail(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestChangeEmail(body: RegistrationChangeEmailBody){
        self.repository
            .requestChangeEmail(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.success("berhasil login"))
                self.changeEmailRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
