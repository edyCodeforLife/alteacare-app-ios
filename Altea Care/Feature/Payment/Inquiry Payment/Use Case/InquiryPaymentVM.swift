//
//  InquiryPaymentVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class InquiryPaymentVM: BaseViewModel {
    
    private let repository: InquiryPaymentRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let inquiryPaymentModelRelay = BehaviorRelay<InquiryPaymentModel?>(value: nil)
    
    struct Input {
        let fetch: Observable<String?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let inquiryPayment : Driver<InquiryPaymentModel?>
    }
    
    init(repository: InquiryPaymentRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeFetch(input)
        return Output(state: self.stateRelay.asDriver().skip(1), inquiryPayment: self.inquiryPaymentModelRelay.asDriver().skip(1))
    }
    
    private func makeFetch(_ input: Input) {
        input
            .fetch
            .compactMap { $0 }
            .subscribe(onNext: { (id) in
                self.stateRelay.accept(.loading)
                self.makeRequestFetch(id: id)
            })
            .disposed(by: self.disposeBag)

    }
    
    private func makeRequestFetch(id: String) {
        self.repository
            .request(body: PaymentInquiryBody(id: id))
            .subscribe { (model) in
                self.inquiryPaymentModelRelay.accept(model)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)

    }
    
}
