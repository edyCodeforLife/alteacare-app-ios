//
//  MedicalResumeVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class MedicalResumeVM: BaseViewModel {
    
    private let repository: MedicalResumeRepository
    private let disposeBag = DisposeBag()
    private let dataRelay = BehaviorRelay<[MedicalResumeModel]>(value: [])
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    
    struct Input {
        let fetch: Observable<String?>
    }
    
    struct Output {
        let data: Driver<[MedicalResumeModel]>
        let state: Driver<BasicUIState>
    }
    
    init(repository: MedicalResumeRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeFetch(input)
        return Output(data: self.dataRelay.asDriver().skip(1),
                      state: self.stateRelay.asDriver().skip(1))
    }
    
    private func makeFetch(_ input: Input) {
        input
            .fetch
            .compactMap { $0 }
            .subscribe(onNext: { (id) in
                self.makeRequestFetch(id: id)
            })
            .disposed(by: self.disposeBag)

    }
    
    private func makeRequestFetch(id: String) {
        self.repository
            .requestMedicalResumeAPI(body: MedicalResumeBody(id: id))
            .subscribe { (model) in
                self.dataRelay.accept(model)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.dataRelay.accept([])
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)

    }
    
}
