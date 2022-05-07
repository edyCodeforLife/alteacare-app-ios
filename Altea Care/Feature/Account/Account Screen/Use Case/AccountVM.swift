//
//  AccountVM.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class AccountVM: BaseViewModel {
    
    private let repository: AccountRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let accountRelay = BehaviorRelay<AccountDataModel?>(value: nil)
    private let logoutRelay = BehaviorRelay<LogoutModel?>(value: nil)
    private let errorAccountRelay = BehaviorRelay<Bool?>(value: nil)
    
    struct Input {
        let viewDidLoadRelay : Observable<Void>
        let logoutRequest : Observable<LogoutBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let accountData : Driver<AccountDataModel?>
        let logoutOutput : Driver<LogoutModel?>
        let errorAccountOutput : Driver<Bool?>
    }
    
    init(repository: AccountRepository) {
        self.repository = repository
    }
    
    private func makeLogout(_ input : Input){
        input
            .logoutRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestLogout(body: body)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    func requestLogout(body : LogoutBody){
        self.repository
            .requestLogout()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.logoutRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func makeAccountData(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestAccountData()
            }.disposed(by: self.disposeBag)
    }
    
    func requestAccountData(){
        self.repository
            .requestGetUserData()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.accountRelay.accept(result)
            } onFailure: { (error) in
                if let httpError = error as? HTTPError, httpError == .expired {
                    Preference.removeString(forKey: .AccessTokenKey)
                    Preference.removeString(forKey: .AccessRefreshTokenKey)
                    self.errorAccountRelay.accept(true)
                    self.stateRelay.accept(.failure(error.readableError))
                }
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        self.makeAccountData(input)
        self.makeLogout(input)
        return Output(state: self.stateRelay.asDriver().skip(1), accountData: self.accountRelay.asDriver().skip(1), logoutOutput: self.logoutRelay.asDriver().skip(1), errorAccountOutput: self.errorAccountRelay.asDriver())
    }
}
