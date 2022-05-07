//
//  ListAddressVM.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class ListAddressVM: BaseViewModel {
    
    private let repository: ListAddressRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let listAddressRelay = BehaviorRelay<[DetailAddressModel]>(value: [])
    
    struct Input {
        let deleteAddressInput : Observable<DeleteAddressBody?>
        let setDefaultAddressInput : Observable<PrimaryAddressBody?>
        let viewDidLoadRelay : Observable<Void>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let listAddressOuput : Driver<[DetailAddressModel]>
    }
    
    init(repository: ListAddressRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestList(input)
        self.makeRequestDeleteAddress(input)
        self.makeRequestSetPrimary(input)
        return Output(state: self.stateRelay.asDriver().skip(1), listAddressOuput: self.listAddressRelay.asDriver().skip(1))
    }
    
    private func requestList() {
        self.repository
            .requestList()
            .subscribe { model in
                self.listAddressRelay.accept(model.data ?? [])
                self.stateRelay.accept(.close)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestList(_ input : Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestList()
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestDeleteAddress(_ input : Input){
        input
            .deleteAddressInput
            .compactMap { $0 }
            .subscribe { (body) in
                guard let id = body.element else { return }
                self.requestDelete(body: id)
            }.disposed(by: self.disposeBag)
    }
    
    private func requestDelete(body: DeleteAddressBody) {
        self.repository
            .requestDelete(body: body)
            .subscribe { model in
                self.stateRelay.accept(.close)
                self.stateRelay.accept(.success("Berhasil dihapus"))
                self.requestList()
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func makeRequestSetPrimary(_ input : Input){
        input
            .setDefaultAddressInput
            .compactMap { $0 }
            .subscribe{ (body) in
                guard let id = body.element else { return }
                self.stateRelay.accept(.loading)
                self.requestPrimary(body: id)
            }.disposed(by: self.disposeBag)
    }
    
    private func requestPrimary(body: PrimaryAddressBody) {
        self.repository
            .requestPrimary(body: body)
            .subscribe { message in
                self.stateRelay.accept(.close)
                self.stateRelay.accept(.success(message))
                self.requestList()
            } onFailure: { error in
                self.stateRelay.accept(.success(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
