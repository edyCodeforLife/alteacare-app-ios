//
//  DrawerCallBookingVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 02/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class DrawerCallBookingVM: BaseViewModel {
    
    private let repository : DrawerCallBookingRepository
    private let settingRepository: SettingRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let createBookingRelay = BehaviorRelay<DataCreateConsultation?>(value: nil)
    private let settingRelay = BehaviorRelay<SettingModel?>(value: nil)

    init(repository : DrawerCallBookingRepository, settingRepository: SettingRepository) {
        self.repository = repository
        self.settingRepository = settingRepository
    }
    
    struct Input {
        let body : Observable<CreateConsultationBody?>
    }
    
    struct Output  {
        let state : Driver<BasicUIState>
        let createBookingData : Driver<DataCreateConsultation?>
        let setting: Driver<SettingModel?>
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestCreateBooking(input)
        return Output(state: self.stateRelay.asDriver().skip(1), createBookingData: self.createBookingRelay.asDriver().skip(1), setting: settingRelay.asDriver().skip(1))
    }
    
    private func makeRequestCreateBooking(_ input : Input){
        input
            .body
            .compactMap {
                self.requestSettings()
                return $0
            }
            .subscribe(onNext: { (body) in
                self.requestCreateBooking(body: body)
            }).disposed(by: self.disposeBag)
    }
    
    private func requestCreateBooking(body : CreateConsultationBody){
        self.repository
            .requestConsultation(body: body)
            .subscribe{ (model) in
                self.stateRelay.accept(.close)
                self.createBookingRelay.accept(model)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func requestSettings(){
        self.settingRepository
            .getSettingModel()
            .subscribe{ (model) in
                self.settingRelay.accept(model)
            } onFailure: { (error) in
            }.disposed(by: self.disposeBag)
    }
}
