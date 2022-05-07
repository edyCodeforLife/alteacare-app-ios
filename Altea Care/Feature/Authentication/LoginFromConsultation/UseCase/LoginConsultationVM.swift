//
//  LoginConsultationVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 04/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class LoginConsultationVM: BaseViewModel {
    
    private let repository: LoginConsulatationRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let logoutRelay = BehaviorRelay<LogoutModel?>(value: nil)
    private let accountRelay = BehaviorRelay<UserHomeData?>(value: nil)
    private let loginRelay = BehaviorRelay<LoginModel?>(value: nil)
    
    let didSignIn = PublishSubject<Void>()
    let didFailSignIn = PublishSubject<Error>()
    
    init(repository: LoginConsulatationRepository) {
        self.repository = repository
    }
    
    struct Input {
        let viewDidLoadRelay : Observable<Void>
        let loginRequest : Observable<LoginBody?>
        let userData : Observable<String?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let loginOutput : Driver<LoginModel?>
        let accountData : Driver<UserHomeData?>
    }
    
    func transform(_ input: Input) -> Output {
//        self.makeLogout(input)
        self.makeAccountData(input)
        self.makeLogin(input)
        return Output(state: self.stateRelay.asDriver().skip(1),
                      loginOutput: self.loginRelay.asDriver().skip(1),
                      accountData: self.accountRelay.asDriver().skip(1))
    }
    
//    private func makeLogout(_ input: Input) {
//        input
//            .logoutRequest
//            .compactMap { $0 }
//            .subscribe(onNext: { (body) in
//                self.requestLogout(body: body)
//            }, onError: { (error) in
//                self.stateRelay.accept(.failure(error.readableError))
//            }).disposed(by: self.disposeBag)
//    }
//
//    func requestLogout(body : LogoutBody){
//        self.repository
//            .requestLogout()
//            .subscribe { (result) in
//                self.stateRelay.accept(.close)
//                self.logoutRelay.accept(result)
//            } onFailure: { (error) in
//                self.stateRelay.accept(
//                    .failure(error.readableError))
//            }.disposed(by: self.disposeBag)
//    }
    
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
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeLogin(_ input : Input) {
        input
            .loginRequest
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestLogin(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    private func requestLogin(body: LoginBody){
        self.repository
            .requestLogin(body: body)
            .subscribe { (result) in
                self.stateRelay.accept(.success("berhasil login"))
                self.loginRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
