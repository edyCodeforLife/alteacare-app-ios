//
//  RequestCancelVM.swift
//  Altea Care
//
//  Created by Hedy on 18/12/21.
//

import Foundation
import RxSwift
import RxCocoa

class RequestCancelVM: BaseViewModel {
    
    private let repository: RequestCancelRepository
    private let disposeBag = DisposeBag()
    private let statusRelay = BehaviorRelay<Bool?>(value: nil)
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    struct Input {
        let request: Observable<Int?>
        let reason: Observable<String?>
    }
    
    struct Output {
        let isSuccess: Driver<Bool?>
        let state: Driver<BasicUIState>
    }
    
    init(repository: RequestCancelRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequest(input)
        return Output(isSuccess: self.statusRelay.asDriver().skip(1), state: self.stateRelay.asDriver().skip(1))
    }
    
    private func makeRequest(_ input: Input) {
        let combine = Observable.combineLatest(input.request, input.reason)
        combine
            .subscribe(onNext: { (id, reason) in
                guard let id = id, let reason = reason else { return }
                self.stateRelay.accept(.loading)
                self.requestCancel(body: UserCancelBody(appointmentId: id, note: reason))
            }).disposed(by: self.disposeBag)

    }
    
    private func requestCancel(body: UserCancelBody) {
        self.repository
            .requestCancel(body: body)
            .subscribe {
                self.statusRelay.accept(true)
                self.stateRelay.accept(.close)
            } onError: { error in
                self.statusRelay.accept(false)
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)

    }
    
}
