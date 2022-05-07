//
//  EditMemberVM.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class EditMemberVM: BaseViewModel {
    
    private let repository: EditMemberRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let detailMemberRelay = BehaviorRelay<EditMemberModel?>(value: nil)
    private let updatedMemberRelay = BehaviorRelay<Bool?>(value: nil)
    private let countryRelay = BehaviorRelay<CountryModel?>(value: nil)
    private let familyRelationRelay = BehaviorRelay<FamilyRelationModel?>(value: nil)
    
    private let idRelay = BehaviorRelay<String?>(value: nil)
    
    struct Input {
        let updateMemberRequest : Observable<UpdateMemberBody?>
        let viewDidLoadRelay: Observable<Void>
        let id : Observable<String?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let detailMemberOutpot : Driver<EditMemberModel?>
        let updatedMemberOutput : Driver<Bool?>
        let familyRelation: Driver<FamilyRelationModel?>
        let countryData : Driver<CountryModel?>
    }
    
    init(repository: EditMemberRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        makeRequestDetail(input)
        makeRequestCountryList(input)
        makeRequestFamilyRelationList(input)
        makeRequestUpdateMember(input)
        return Output(state: self.stateRelay.asDriver().skip(1),
                      detailMemberOutpot: self.detailMemberRelay.asDriver().skip(1),
                      updatedMemberOutput: updatedMemberRelay.asDriver().skip(1),
                      familyRelation: self.familyRelationRelay.asDriver().skip(1),
                      countryData: self.countryRelay.asDriver().skip(1))
    }
    
    private func makeRequestDetail(_ input: Input) {
        input
            .id
            .compactMap { $0 }
            .subscribe { (value) in
                self.idRelay.accept(value.element)
                self.stateRelay.accept(.loading)
                self.requestDetail(body: DetailMemberBody(id: value.element ?? ""))
            }.disposed(by: self.disposeBag)
    }
    
    private func requestDetail(body: DetailMemberBody) {
        self.repository
            .requestDetail(body: body)
            .subscribe { model in
                self.detailMemberRelay.accept(model)
                self.stateRelay.accept(.close)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestCountryList(_ input: Input) {
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestGetCountry()
            }.disposed(by: self.disposeBag)
    }
    
    func requestGetCountry(){
        self.repository
            .requestGetCountry()
            .subscribe(onSuccess: { (result) in
                self.stateRelay.accept(.close)
                self.countryRelay.accept(result)
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    private func makeRequestFamilyRelationList(_ input: Input) {
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestGetFamilyRelations()
            }.disposed(by: self.disposeBag)
    }
    
    
    func requestGetFamilyRelations(){
        self.repository
            .requestGetFamilyRelations()
            .subscribe(onSuccess: { (result) in
                self.stateRelay.accept(.close)
                self.familyRelationRelay.accept(result)
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    private func makeRequestUpdateMember(_ input: Input) {
        input
            .updateMemberRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestUpdate(id: self.idRelay.value ?? "", body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestUpdate(id: String, body: UpdateMemberBody) {
        self.repository
            .requestUpdate(id: id, body: body)
            .subscribe { model in
                self.stateRelay.accept(.success("Berhasil memperbaharui profil"))
                self.updatedMemberRelay.accept(true)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
