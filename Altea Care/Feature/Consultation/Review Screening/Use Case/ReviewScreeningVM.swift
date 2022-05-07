//
//  ReviewScreeningVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewScreeningVM: BaseViewModel {
    
    private let repository: ReviewScreeningRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let modelRelay = BehaviorRelay<PatientDataModel?>(value: nil)
    private var timeRepeat = 1
    private var statusPayment = ""
    private var timer: Timer!
    
    struct Input {
        let fetch: Observable<String?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let model: Driver<PatientDataModel?>
    }
    
    init(repository: ReviewScreeningRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeFetch(input)
        return Output(state: self.stateRelay.asDriver().skip(1),
                      model: self.modelRelay.asDriver().skip(1))
    }
    
    private func makeFetch(_ input: Input) {
        input
            .fetch
            .compactMap { $0 }
            .subscribe(onNext: { (id) in
                self.stateRelay.accept(.loading)
                if self.statusPayment.isEmpty {
                    self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { time in
                        if self.statusPayment != "WAITING_FOR_PAYMENT" {
                            if self.timeRepeat < 12 {
                                self.requestPatientData(id: id)
                                self.timeRepeat = self.timeRepeat+1
                            } else {
                                self.timeRepeat = 0
                                if self.timer != nil {
                                    self.timer.invalidate()
                                }
                            }
                            
                        } else {
                            if self.timer != nil {
                                self.timer.invalidate()
                            }
                        }
                    })
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func requestPatientData(id: String) {
        self.repository
            .requestPatientData(body: PatientDataBody(id: id))
            .subscribe { (result) in
                self.statusPayment = result.status.rawValue
                self.modelRelay.accept(result)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
                if self.timer != nil {
                    self.timer.invalidate()
                }
                
            }.disposed(by: self.disposeBag)
    }
    
}
