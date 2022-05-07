//
//  ReviewPaymentVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewPaymentVM: BaseViewModel {
    
    private let repository: ReviewPaymentRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    private let dataAppointmentRelay = BehaviorRelay<ReviewPaymentModel?>(value: nil)
    
    init(repository: ReviewPaymentRepository) {
        self.repository = repository
    }
    
    struct Input {
        let viewDidLoadRelay : Observable<Void>
        let detailAppointmentRelay : Observable<DetailAppointmentBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let appointmentDetailState : Driver<ReviewPaymentModel?>
    }
    
    private func makeRequestDetailAppointment(_ input : Input){
        input
            .detailAppointmentRelay
            .compactMap{ $0 }
            .subscribe(onNext: { (body) in
                self.requestDetailAppointment(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    private func requestDetailAppointment(body : DetailAppointmentBody){
        self.repository
            .requestAppointmentDetail(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.success(""))
                self.dataAppointmentRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestDetailAppointment(input)
        return Output(state: self.stateRelay.asDriver().skip(1), appointmentDetailState: self.dataAppointmentRelay.asDriver().skip(1))
    }
    
}
