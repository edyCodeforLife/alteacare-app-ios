//
//  ListDoctorVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ListDoctorVM: BaseViewModel {
    
    private let repositorySpecialists: ListSpecialistRepository
    private let repositoryHospitals: FilterListHospitalRepository
    private let repositoryDoctors: ListDoctorRepository
    private let repositorySearch: SearchAutocompleteRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private var dayRelay = BehaviorRelay<String>(value: "")
    
    private let specializationsRelay = BehaviorRelay<[ListSpecialistModel]>(value: [])
    private let hospitalsRelay = BehaviorRelay<[ListHospitalModel]>(value: [])
    private let doctorsRelay = BehaviorRelay<[ListDoctorModel]>(value: [])
    
    struct Input {
        let viewDidLoadRelay: Observable<Void>
//        let idSpecialization: Observable<String?>
//        let isSearch: Observable<Bool?>
//        let request: Observable<ListDoctorSpecializationBody?>
        let modelSpecializations: Observable<SpecializationsRequest?>
        let modelDoctors: Observable<DoctorsSpecializationBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let specializations: Driver<[ListSpecialistModel]>
        let hospitals: Driver<[ListHospitalModel]>
        let doctors: Driver<[ListDoctorModel]>
//        let doctorSpecialization: Driver<[ListDoctorModel]>
    }
    
    init(repositoryDoctors: ListDoctorRepository,
         repositorySearch: SearchAutocompleteRepository,
         repositorySpecialists: ListSpecialistRepository,
         repositoryHospitals: FilterListHospitalRepository) {
        self.repositoryDoctors = repositoryDoctors
        self.repositorySearch = repositorySearch
        self.repositorySpecialists = repositorySpecialists
        self.repositoryHospitals = repositoryHospitals
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestDoctorList(input)
        return Output(
            state: self.stateRelay.asDriver().skip(1),
            specializations: specializationsRelay.asDriver().skip(1),
            hospitals: hospitalsRelay.asDriver().skip(1),
            doctors: doctorsRelay.asDriver().skip(1))
    }

    func makeRequestDoctorList(_ input: Input) {
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.makeSpecializationsApiService(input)
                self.makeHospitalsApiService()
                self.makeDoctorsApiService(input)

                // self.makeRequestDoctorSpecializationList(input) // sementara di comend dulu
            }.disposed(by: self.disposeBag)
    }
    
    private func makeSpecializationsApiService(_ input: Input) {
        input
            .modelSpecializations
            .compactMap { $0 }
            .subscribe { (req) in
                self.repositorySpecialists
                    .requestSpecializations(req)
                    .subscribe { (result) in
                        self.stateRelay.accept(.close)
                        self.specializationsRelay.accept(result)
                    } onFailure: { (error) in
                        self.stateRelay.accept(.close)
                    }.disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)
        
    }
    
    private func makeHospitalsApiService() {
        self.repositoryHospitals
            .requestHospitals()
            .subscribe{ (result) in
                self.stateRelay.accept(.close)
                self.hospitalsRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.close)
            }.disposed(by: self.disposeBag)
    }
    
    private func makeDoctorsApiService(_ input: Input) {
        input
            .modelDoctors
            .compactMap { $0 }
            .subscribe { (req) in
                self.repositoryDoctors
                    .requestDoctorsSpecialist(body: req)
                    .subscribe { (result) in
                        self.stateRelay.accept(.close)
                        self.doctorsRelay.accept(result)
                    } onFailure: { (error) in
                        self.stateRelay.accept(.close)
                    }.disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)
        
        
    }
}
