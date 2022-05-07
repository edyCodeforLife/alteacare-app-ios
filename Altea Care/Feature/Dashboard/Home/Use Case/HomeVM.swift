//
//  HomeVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class HomeVM: BaseViewModel {
    
    private let repository: HomeRepository
    private let settingRepository: SettingRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let consultationListRelay = BehaviorRelay<[OngoingConsultationModel]>(value: [])
    private let specialistPopularRelay = BehaviorRelay<[ListSpecialistModel]>(value: [])
    private let userDataRelay = BehaviorRelay<UserHomeData?>(value: nil)
    private let bannerRelay = BehaviorRelay<[BannerModel]>(value: [])
    private let listMemberRelay = BehaviorRelay<[MemberModel]>(value: [])
    private let forceUpdateRelay = BehaviorRelay<ForceUpdateModel?>(value: nil)
    private let settingRelay = BehaviorRelay<SettingModel?>(value: nil)
    private let errorUserDataRelay = BehaviorRelay<Bool?>(value: nil)
    private let widgetsRelay = BehaviorRelay<[WidgetModel]>(value: [])
    
    
    struct Input {
        let viewDidLoadRelay: Observable<Void>
        let updateRelay : Observable<Void>
        let fetchUserData : Observable<String?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let consultationList: Driver<[OngoingConsultationModel]>
        let specialistPopular: Driver<[ListSpecialistModel]>
        let userData : Driver<UserHomeData?>
        let bannerData : Driver<[BannerModel]>
        let listMemberOutput: Driver<[MemberModel]>
        let forceUpdateOutput : Driver<ForceUpdateModel?>
        let settingOutput: Driver<SettingModel?>
        let errorUserDataOutput: Driver<Bool?>
        let widgetsOutput: Driver<[WidgetModel]>
    }
    
    init(repository: HomeRepository, settingRepository: SettingRepository) {
        self.repository = repository
        self.settingRepository = settingRepository
    }
    
    private func makeRequestForceUpdate(_ input : Input){
        input
            .updateRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestForceUpdate()
            }.disposed(by: self.disposeBag)
    }
    
    private func requestForceUpdate(){
        self.repository
            .requestForceUpdate()
            .subscribe(onSuccess: { (result) in
                self.stateRelay.accept(.close)
                self.forceUpdateRelay.accept(result)
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func makeFetchUserData(_  input : Input) {
        input
            .viewDidLoadRelay
            .subscribe{ (_) in
                self.stateRelay.accept(.loading)
                self.getSetting()
                self.requestUserData()
            }.disposed(by: self.disposeBag)
    }
    
    private func getSetting(){
        self.settingRepository
            .getSettingModel()
            .subscribe{ result in
                self.settingRelay.accept(result)
            } onFailure: { (error) in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func requestList() {
        self.repository
            .requestList()
            .subscribe { model in
                self.listMemberRelay.accept(model.model ?? [])
                self.stateRelay.accept(.close)
            } onFailure: { error in
                //                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestListMember(_ input : Input) {
        input.viewDidLoadRelay
            .subscribe { (body) in
                self.stateRelay.accept(.loading)
                self.requestList()
            }.disposed(by: self.disposeBag)
    }
    
    func requestUserData() {
        self.repository
            .requestGetUserData()
            .subscribe { (model) in
                self.userDataRelay.accept(model)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                if let httpError = error as? HTTPError, httpError == .expired {
                    Preference.removeString(forKey: .AccessTokenKey)
                    Preference.removeString(forKey: .AccessRefreshTokenKey)
                    self.errorUserDataRelay.accept(true)
                    self.stateRelay.accept(.failure(error.readableError))
                }
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestSpecialistPopular(_ input: Input) {
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestSpecialistPopular()
            }.disposed(by: self.disposeBag)
    }
    
    func requestSpecialistPopular() {
        self.repository
            .requestSpecialistPopular()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.specialistPopularRelay.accept(result)
            } onFailure: { (error) in
                //                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestConsultationList(_ input: Input) {
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestListConsultation(body: ListConsultationBody())
            }.disposed(by: self.disposeBag)
    }
    
    private func requestListConsultation(body: ListConsultationBody) {
        let filter = ListConsultationBody(keyword: nil, sort: nil, sortType: nil, page: 1, startDate: Date().toStringDefault(), endDate: Date().toStringDefault())
        self.repository
            .requestList(body: filter)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.consultationListRelay.accept(result.model)
            } onFailure: { (error) in
                self.stateRelay.accept(.close)
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestBannerData(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestBannerData()
            }.disposed(by: self.disposeBag)
    }
    
    private func requestBannerData(){
        self.repository
            .requestBanner(category: .telemedicine)
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.bannerRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestWidgetData(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestWidgetsData()
            }.disposed(by: self.disposeBag)
    }
    
    private func requestWidgetsData() {
        self.repository
            .requestWidgets()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.widgetsRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestSpecialistPopular(input)
        self.makeFetchUserData(input)
        self.makeRequestConsultationList(input)
        self.makeRequestBannerData(input)
        self.makeRequestListMember(input)
        self.makeRequestForceUpdate(input)
        self.makeRequestWidgetData(input)
        return Output(state: self.stateRelay.asDriver().skip(1), consultationList: self.consultationListRelay.asDriver().skip(1), specialistPopular: specialistPopularRelay.asDriver().skip(1), userData: userDataRelay.asDriver().skip(1), bannerData: bannerRelay.asDriver().skip(1), listMemberOutput: self.listMemberRelay.asDriver().skip(1), forceUpdateOutput: self.forceUpdateRelay.asDriver().skip(1), settingOutput: self.settingRelay.asDriver().skip(1), errorUserDataOutput: self.errorUserDataRelay.asDriver(), widgetsOutput: self.widgetsRelay.asDriver().skip(1))
    }
    
}
