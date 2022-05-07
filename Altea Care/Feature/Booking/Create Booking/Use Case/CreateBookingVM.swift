//
//  CreateBookingVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class CreateBookingVM: BaseViewModel {
    
    private let repository: CreateBookingRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let detailConsultationRelay = BehaviorRelay<CreateBookingModel?>(value: nil)
    
    struct Input {
        let viewDidLoadRelay: Observable<Void>
        let idAppointment: Observable<String?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let detailConsultation: Driver<CreateBookingModel?>
    }
    
    init(repository: CreateBookingRepository) {
        self.repository = repository
    }
    
    func makeRequestDetailConsultation(_ input: Input) {
        input
            .idAppointment
            .compactMap { $0 }
            .subscribe(onNext: { (id) in
                self.stateRelay.accept(.loading)
                self.requestDetailConsultation(id: id)
            }).disposed(by: self.disposeBag)
    }
    
    private func requestDetailConsultation(id: String) {
        self.repository
            .requestAppointment(id: id)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.detailConsultationRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
            
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestDetailConsultation(input)
        return Output(state: self.stateRelay.asDriver().skip(1), detailConsultation: self.detailConsultationRelay.asDriver().skip(1))
    }
    
}
