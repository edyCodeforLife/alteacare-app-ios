//
//  PaymentMethodVM.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class PaymentMethodVM: BaseViewModel {
    
    private let repository: PaymentMethodRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let paymentListRelay = BehaviorRelay<[PaymentMethodModel]>(value: [])
    private let paymentSelectedRelay = BehaviorRelay<PaymentMethodSelectedModel?>(value: nil)
    private let voucherSelectedRelay = BehaviorRelay<VoucherBody?>(value: nil)
    struct Input {
        let viewDidLoadRelay: Observable<Void>
        let selectedPayment: Observable<PaymentMethodModelItem?>
        let idConsultation : Int
        let voucherBody: VoucherBody?
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let paymentList : Driver<[PaymentMethodModel]>
        let paymentSelected: Driver<PaymentMethodSelectedModel?>
    }
    
    init(repository: PaymentMethodRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestListPaymentMethod(input)
        self.makeRequestPay(input)
        self.voucherSelectedRelay.accept(input.voucherBody)
        return Output(state: stateRelay.asDriver().skip(1), paymentList: paymentListRelay.asDriver().skip(1), paymentSelected: paymentSelectedRelay.asDriver().skip(1))
    }
    
    private func makeRequestListPaymentMethod(_ input: Input) {
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestListPaymentMethod(body: PaymentMethodBody(voucher_code: input.voucherBody?.code ?? "", transaction_id: input.idConsultation, type_of_service: "TELEKONSULTASI"))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestPay(_ input: Input) {
        input
            .selectedPayment
            .asObservable()
            .subscribe(onNext: { (selected) in
                self.stateRelay.accept(.loading)
                guard let selected = selected else {return}
                self.requestPay(appointmentID: input.idConsultation, method: selected.code)
            })
            .disposed(by: disposeBag)

    }
    
    private func requestListPaymentMethod(body:PaymentMethodBody?) {
        self.repository
            .request(parameter: body?.dictionary ??  [String:Any]())
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.paymentListRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func requestPay(appointmentID: Int, method: String) {
        self.repository
            .requestPayment(body: PayConsultationBody(appointment_id: appointmentID, method:method, voucher_code : voucherSelectedRelay.value?.code ?? ""))
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.paymentSelectedRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
