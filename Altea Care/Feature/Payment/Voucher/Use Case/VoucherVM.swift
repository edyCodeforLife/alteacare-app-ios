//
//  VoucherVM.swift
//  Altea Care
//
//  Created by Tiara on 11/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class VoucherVM: BaseViewModel {
    
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let voucherOutputRelay = BehaviorRelay<VoucherModel?>(value: nil)
    private let repository: VoucherRepository
    private let disposeBag = DisposeBag()
    
    init(repository: VoucherRepository) {
        self.repository = repository
    }
    
    struct Input {
        let viewDidLoadRelay: Observable<Void>
        let voucher: Observable<VoucherBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let voucherOutput : Driver<VoucherModel?>
    }
    
    func transform(_ input: Input) -> Output {
        makeRequestSearchVoucher(input)
        return Output(state: stateRelay.asDriver().skip(1),
                      voucherOutput: voucherOutputRelay.asDriver().skip(1))
    }
    
    private func makeRequestSearchVoucher(_ input: Input) {
        input
            .voucher
            .asObservable()
            .subscribe (onNext:{ [weak self](voucher) in
                guard let self = self else{return}
                self.stateRelay.accept(.loading)
                if let v = voucher {
                    self.requestSearchVoucher(voucher: v)
                }
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestSearchVoucher(voucher: VoucherBody) {
        self.repository
            .request(body: voucher)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.voucherOutputRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.close)
                self.voucherOutputRelay.accept(VoucherModel(status: false, voucher: nil))
            }.disposed(by: self.disposeBag)
    }
    
}
