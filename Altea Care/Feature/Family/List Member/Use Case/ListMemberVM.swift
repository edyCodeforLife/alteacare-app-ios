//
//  ListMemberVM.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class ListMemberVM: BaseViewModel {
    
    private let repository: ListMemberRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let listMemberRelay = BehaviorRelay<[MemberModel]>(value: [])
    
    struct Input {
        let viewDidloadRelay : Observable<Void>
        let defaultMemberRequest : Observable<SetDefaultMemberBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let listMemberOutput: Driver<[MemberModel]>
    }
    
    init(repository: ListMemberRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestListMember(input)
        self.makeRequestDefaultMember(input)
        return Output(state: self.stateRelay.asDriver().skip(1), listMemberOutput: self.listMemberRelay.asDriver())
    }
    
    private func requestList() {
        self.repository
            .requestList()
            .subscribe { model in
                self.listMemberRelay.accept(model.model ?? [])
                self.stateRelay.accept(.close)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestListMember(_ input : Input) {
        input.viewDidloadRelay
            .subscribe { (body) in
                self.stateRelay.accept(.loading)
                self.requestList()
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestDefaultMember(_ input : Input) {
        input.defaultMemberRequest
            .compactMap { $0 }
            .subscribe { (body) in
                self.stateRelay.accept(.loading)
                guard let e = body.element else {return}
                self.requestDefaultMember(body: e)
            }.disposed(by: self.disposeBag)
    }
    
    private func requestDefaultMember(body: SetDefaultMemberBody) {
        self.repository
            .requestDefaultMember(body: body)
            .subscribe { model in
                self.stateRelay.accept(.success("Berhasil"))
                self.stateRelay.accept(.close)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
