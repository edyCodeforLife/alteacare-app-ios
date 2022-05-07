//
//  AlteaPaymentWebViewVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 28/06/21.
//

import Foundation
import RxSwift
import RxCocoa

class AlteaPaymentWebViewVM: BaseViewModel {
    
    private let repository : AlteaPaymentWebViewRepository
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let statusCheckRelay = BehaviorRelay<StatusPaymentModel?>(value: nil)
    private let disposeBag = DisposeBag()
    
    init(repository: AlteaPaymentWebViewRepository) {
        self.repository = repository
    }
    
    struct Input{
        let viewDidLoadRelay : Observable<Void>
        let statusRequestRelay : Observable<DetailAppointmentBody?>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let statusOutput : Driver<StatusPaymentModel?>
    }
    
    private func makeRequestStatus(_ input : Input){
        input
            .statusRequestRelay
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestStatus(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    private func requestStatus(body : DetailAppointmentBody){
        self.repository
            .requestStatusPayment(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.statusCheckRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestStatus(input)
        return Output(state: stateRelay.asDriver().skip(1), statusOutput: statusCheckRelay.asDriver().skip(1))
    }
}
