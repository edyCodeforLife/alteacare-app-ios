//
//  AddMemberVM.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class AddMemberVM: BaseViewModel {
    
    private let repository: AddMemberRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let countryRelay = BehaviorRelay<CountryModel?>(value: nil)
    private let familyRelationRelay = BehaviorRelay<FamilyRelationModel?>(value: nil)
    private let addMemberDataRelay = BehaviorRelay<AddMemberModel?>(value: nil)
    private let errorAddMemberDataRelay = BehaviorRelay<Error?>(value: nil)
    
    struct Input {
        let viewDidLoadRelay: Observable<Void>
        let addMemberRequest : Observable<AddMemberBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let familyRelation: Driver<FamilyRelationModel?>
        let countryData : Driver<CountryModel?>
        let addMemberOutput : Driver<AddMemberModel?>
        let errorAddMemberOutput: Driver<Error?>

    }
    
    init(repository: AddMemberRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        makeRequestCountryList(input)
        makeRequestFamilyRelationList(input)
        makeRequestAddMember(input)
        return Output(state: self.stateRelay.asDriver().skip(1),
                      familyRelation: self.familyRelationRelay.asDriver().skip(1),
                      countryData: self.countryRelay.asDriver().skip(1),
                      addMemberOutput: self.addMemberDataRelay.asDriver().skip(1),
                      errorAddMemberOutput: self.errorAddMemberDataRelay.asDriver()
                      )
    }
    
    private func makeRequestFamilyRelationList(_ input: Input) {
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestGetFamilyRelations()
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
    
    private func makeRequestAddMember(_ input : Input) {
        input
            .addMemberRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestAdd(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestAdd(body: AddMemberBody){
        self.repository
            .requestAdd(body: body)
            .subscribe { (result) in
                self.addMemberDataRelay.accept(result)
                self.stateRelay.accept(.success("Berhasil menambah anggota keluarga"))
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
                self.errorAddMemberDataRelay.accept(error)
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
}
