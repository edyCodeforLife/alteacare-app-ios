//
//  OldPasswordVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 05/04/21.
//

import Foundation
import RxSwift
import RxCocoa

class OldPasswordVM: BaseViewModel {
    
    private let repository : OldPasswordRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let checkOldPasswordRelay =  BehaviorRelay<OldPasswordModel?>(value: nil)
    
    struct Input {
//        let viewDidLoadRelay : Observable<Void?>
        let checkOldPasswordInput : Observable<CheckOldPasswordBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let checkOldPasswordOutput : Driver<OldPasswordModel?>
    }
    
    init(repository: OldPasswordRepository) {
        self.repository = repository
    }
    
    func makeRequestCheckOldPassword(_ input : Input){
        input
            .checkOldPasswordInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestCheckOldPassword(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure("Check Password Gagal"))
            }).disposed(by: self.disposeBag)
    }
    
    func requestCheckOldPassword(body : CheckOldPasswordBody){
        self.repository
            .requestCheckOldPassword(body: body)
            .subscribe(onSuccess: { (model) in
                self.checkOldPasswordRelay.accept(model)
                self.stateRelay.accept(.success("Check Password Berhasil"))
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure("Password Lama Anda Tidak Sesuai"))
            }).disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestCheckOldPassword(input)
        return Output(state: self.stateRelay.asDriver().skip(1), checkOldPasswordOutput: self.checkOldPasswordRelay.asDriver().skip(1))
    }
}
