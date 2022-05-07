//
//  RegisterMemberVM.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterMemberVM: BaseViewModel {
    
    private let repository: RegisterMemberRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let idRelay = BehaviorRelay<String?>(value: nil)
    private let registMemberOutputRelay = BehaviorRelay<Bool?>(value: nil)
    private let addMemberOutputRelay = BehaviorRelay<AddMemberModel?>(value: nil)
    struct Input {
        let registMemberRequest : Observable<RegisterMemberBody?>
        let id : Observable<String?>
        let addMemberRequest : Observable<AddMemberBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let registMemberOutput : Driver<Bool?>
        let addMemberOutput : Driver<AddMemberModel?>
    }
    
    init(repository: RegisterMemberRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        makeRequestRegistMember(input)
        makeRequestAddMember(input)
        input
            .id
            .subscribe(onNext: { (id) in
                self.idRelay.accept(id)
            }, onError: { (error) in
            }, onCompleted: {
            }).disposed(by: self.disposeBag)
        
        return Output(state: stateRelay.asDriver().skip(1),
                      registMemberOutput: registMemberOutputRelay.asDriver().skip(1),
                      addMemberOutput: addMemberOutputRelay.asDriver().skip(1))
    }
    
    private func makeRequestRegistMember(_ input: Input) {
        input
            .registMemberRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestRegistMember(id: self.idRelay.value ?? "", body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestRegistMember(id: String, body: RegisterMemberBody) {
        self.repository
            .requestRegister(id: id, body: body)
            .subscribe { model in
                self.registMemberOutputRelay.accept(true)
                self.stateRelay.accept(.success("Berhasil mengirim verifikasi"))
                self.stateRelay.accept(.close)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestAddMember(_ input : Input) {
        input
            .addMemberRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestAdd(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestAdd(body: AddMemberBody){
        self.repository
            .requestAdd(body: body)
            .subscribe { (result) in
                self.addMemberOutputRelay.accept(result)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
}
