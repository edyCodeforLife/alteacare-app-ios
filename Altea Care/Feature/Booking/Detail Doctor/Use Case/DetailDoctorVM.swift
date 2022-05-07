//
//  DetailDoctorVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class DetailDoctorVM: BaseViewModel {
    
    private let repository: DetailDoctorRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let doctorDetailsScheduleRelay =  BehaviorRelay<DoctorScheduleModel?>(value: nil)
    private let doctorDetailsRelay = BehaviorRelay<DetailDoctorModel?>(value: nil)
    private let termRefundCancelRelay = BehaviorRelay<TermRefundCancelModel?>(value: nil)
    private let errorscheduleRelay = BehaviorRelay<Bool?>(value: nil)
    
    struct Input {
        let doctorDetailsData : Observable<String?>
        let scheduleData : Observable<DoctorScheduleBody>
        let viewDidLoadRelay : Observable<Void>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let doctorDetailsSchedule : Driver<DoctorScheduleModel?>
        let doctorDataDetails : Driver<DetailDoctorModel?>
        let termRefundCancel : Driver<TermRefundCancelModel?>
        let errorSchedule : Driver<Bool?>
    }
    
    init(repository: DetailDoctorRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestDoctorDetails(input)
        self.makeRequestDoctorSchedule(input)
        self.makeRequestTermCancel(input)
        return Output(state: self.stateRelay.asDriver().skip(1), doctorDetailsSchedule: self.doctorDetailsScheduleRelay.asDriver().skip(1), doctorDataDetails: self.doctorDetailsRelay.asDriver().skip(1), termRefundCancel: self.termRefundCancelRelay.asDriver().skip(1), errorSchedule: self.errorscheduleRelay.asDriver().skip(1))
    }
    
    func makeRequestDoctorDetails(_ input : Input) {
        input
            .doctorDetailsData
            .subscribe { (id) in
                self.requestDoctorDetails(id: id ?? "")
            } onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestDoctorSchedule(_ input : Input) {
        input
            .scheduleData
            .subscribe { (body) in
                self.requestDoctorSchedule(body: body)
            } onError: { (error) in
//                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestTermCancel(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestTermCancel()
            }.disposed(by: self.disposeBag)
    }
    
    func requestTermCancel(){
        self.repository
            .requestTermCancelRefund()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.termRefundCancelRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func requestDoctorDetails(id : String){
        self.repository
            .requestDoctorData(id: id)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.doctorDetailsRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.close)
//                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func requestDoctorSchedule(body : DoctorScheduleBody){
        self.repository
            .requestDoctorSchedule(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.doctorDetailsScheduleRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.close)
                self.errorscheduleRelay.accept(true)
//                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
