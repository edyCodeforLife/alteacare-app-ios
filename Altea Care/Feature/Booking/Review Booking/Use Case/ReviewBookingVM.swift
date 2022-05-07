//
//  ReviewBookingVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewBookingVM: BaseViewModel {
    
    private let repository: ReviewBookingRepository
    private let repositoryPatient: PatientDataRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let patientDataRelay = BehaviorRelay<PatientDataModel?>(value: nil)
    
    struct Input {
        let fetch: Observable<String?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let patientData : Driver<PatientDataModel?>
    }
    
    struct InputCreateBooking {
        let body: Observable<CreateConsultationBody?>
    }
    
    init(repository: ReviewBookingRepository, repositoryPatient : PatientDataRepository) {
        self.repository = repository
        self.repositoryPatient = repositoryPatient
    }
    
    func transform(_ input: Input) -> Output {
        self.makeFetch(input)
        return Output(state: self.stateRelay.asDriver().skip(1), patientData: self.patientDataRelay.asDriver().skip(1))
    }
    
    private func makeFetch(_ input: Input){
        input
            .fetch
            .compactMap { $0 }
            .subscribe(onNext: { (id) in
                self.makeRequestFetch(id: id)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func makeRequestFetch(id: String) {
        self.repositoryPatient
            .requestPatientData(body: PatientDataBody(id: id))
            .subscribe { (model) in
                self.patientDataRelay.accept(model)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)

    }
}
