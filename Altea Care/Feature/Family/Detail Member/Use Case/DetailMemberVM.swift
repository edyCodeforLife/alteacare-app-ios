//
//  DetailMemberVM.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class DetailMemberVM: BaseViewModel {
    
    private let repository: DetailMemberRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let detailMemberRelay =  BehaviorRelay<DetailMemberModel?>(value: nil)
    
    struct Input {
        let detailMemberInput : Observable<DetailMemberBody?>
        let deletMemberInput : Observable<DeleteMemberBody?>
        let viewDidloadRelay : Observable<Void>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let detailMemberOutput : Driver<DetailMemberModel?>
    }
    
    init(repository: DetailMemberRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestDetailMember(input)
        self.makeRequestDeletMember(input)
        return Output(state: self.stateRelay.asDriver().skip(1), detailMemberOutput: self.detailMemberRelay.asDriver().skip(1))
    }
    
    private func makeRequestDetailMember(_ input: Input){
        input
            .detailMemberInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestDetail(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestDetail(body: DetailMemberBody) {
        self.repository
            .requestDetail(body: body)
            .subscribe { model in
                self.detailMemberRelay.accept(model)
                self.stateRelay.accept(.close)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestDeletMember(_ input : Input){
        input
            .deletMemberInput
            .compactMap { $0 }
            .subscribe { (body) in
//                self.stateRelay.accept(.loading)
                guard let id = body.element else { return }
                self.requestDelete(body: id)
            }.disposed(by: self.disposeBag)
    }
    
    private func requestDelete(body: DeleteMemberBody) {
        self.repository
            .requestDelete(body: body)
            .subscribe { model in
                self.stateRelay.accept(.success("Berhasil"))
            } onFailure: { error in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
