//
//  ConsultationExpiredVM.swift
//  Altea Care
//
//  Created by Tiara Mahardika on 17/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class ConsultationExpiredVM: BaseViewModel {
    
    private let repository: ConsultationExpiredRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    private let dataAppointmentRelay = BehaviorRelay<CancelConsultationModel?>(value: nil)
    
    init(repository: ConsultationExpiredRepository) {
        self.repository = repository
    }
    
    struct Input {
        let viewDidLoadRelay : Observable<Void>
        let detailAppointmentRelay : Observable<DetailAppointmentBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let appointmentDetailState : Driver<CancelConsultationModel?>
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
