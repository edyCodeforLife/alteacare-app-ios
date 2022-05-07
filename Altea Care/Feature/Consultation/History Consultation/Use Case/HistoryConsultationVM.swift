//
//  HistoryConsultationVM.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class HistoryConsultationVM: BaseViewModel {
    
    private let repository: HistoryConsultationRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let consultationListRelay = BehaviorRelay<[HistoryConsultationModel]>(value: [])
    private let consultationMutableListRelay = BehaviorRelay<[HistoryConsultationModel]>(value: [])
    private let isFullyLoadedRelay = BehaviorRelay<Bool>(value: false)
    private let listPatientRelay = BehaviorRelay<[MemberModel]>(value: [])
    
    struct Input {
        let viewDidLoadRelay: Observable<Void>
        let filterDay: Observable<ListConsultationBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let consultationList: Driver<[HistoryConsultationModel]>
        let consultationMutableList: Driver<[HistoryConsultationModel]>
        let isFullyLoaded: Driver<Bool>
        let listMemberOutput: Driver<[MemberModel]>
    }
    
    init(repository: HistoryConsultationRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestConsultationList(input)
        self.makeFilterConsultation(input)
        self.makeRequestListMember(input)
        return Output(state: stateRelay.asDriver().skip(1),
                      consultationList: consultationListRelay.asDriver().skip(1),
                      consultationMutableList: consultationMutableListRelay.asDriver().skip(1),
                      isFullyLoaded: isFullyLoadedRelay.asDriver().skip(1),
                      listMemberOutput: listPatientRelay.asDriver().skip(1))
    }
    
    private func makeRequestConsultationList(_ input: Input) {
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestListConsultation(body: ListConsultationBody(keyword: nil, sort: nil, sortType: "DESC", page: nil, startDate: nil, endDate: nil, patientId: nil))
            }.disposed(by: self.disposeBag)
    }
    
    private func requestListConsultation(body: ListConsultationBody) {
        self.repository
            .requestList(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.isFullyLoadedRelay.accept(result.isFullyLoaded)
                self.consultationListRelay.accept(result.model)
            } onFailure: { (error) in
                self.stateRelay.accept(.close)
//                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeFilterConsultation(_ input: Input) {
        input
            .filterDay
            .compactMap { $0 }
            .subscribe { (body) in
                self.requestMutableListConsultation(body: body)
            } onError: { (error) in
                self.stateRelay.accept(.close)
//                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func requestMutableListConsultation(body: ListConsultationBody) {
        self.repository
            .requestList(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.isFullyLoadedRelay.accept(result.isFullyLoaded)
                if !result.model.isEmpty {
                    self.consultationMutableListRelay.accept(result.model)
                }
            } onFailure: { (error) in
                self.stateRelay.accept(.close)
//                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestListMember(_ input : Input) {
        input.viewDidLoadRelay
            .subscribe { (body) in
                self.stateRelay.accept(.loading)
                self.requestListPatient()
            }.disposed(by: self.disposeBag)
    }
    
    private func requestListPatient() {
        self.repository
            .requestListPatient()
            .subscribe { model in
                self.listPatientRelay.accept(model.model ?? [])
                self.stateRelay.accept(.close)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
