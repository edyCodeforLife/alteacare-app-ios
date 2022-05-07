//
//  RegisterVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterVM: BaseViewModel {
    
    private let repository : RegisterRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value : .loading)
    private let getCountryRelay = BehaviorRelay<CountryModel?>(value: nil)
    
    struct Input {
        let viewDidLoadRelay : Observable<Void>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let countryData : Driver<CountryModel?>
    }
    
    init(repository : RegisterRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeGetCountry(input)
        return Output(state: self.stateRelay.asDriver().skip(1), countryData: self.getCountryRelay.asDriver().skip(1))
    }
    
    private func makeGetCountry(_ input : Input) {
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
            .map{(country) -> CountryModel in
                let sortedCountry = country?.data.sorted { (lhs: CountryData, rhs: CountryData) -> Bool in
                    return lhs.name < rhs.name
                }
                return CountryModel(status: country?.status ?? false, message: country?.message ?? "", data: sortedCountry ?? [])
            }
            .subscribe(onSuccess: { (result) in
                self.stateRelay.accept(.close)
                self.getCountryRelay.accept(result)
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
}
