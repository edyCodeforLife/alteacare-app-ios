//
//  FaqVM.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxCocoa
import RxSwift

class FaqVM : BaseViewModel {
    
    private let repositoryFaq : FaqRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let faqRelay = BehaviorRelay<[FaqModel]>(value : [])
    
    struct Input {
        let viewDidLoadRelay : Observable<Void>
    }
    
    struct Output {
        let state : Driver<BasicUIState>
        let faqOutput : Driver<[FaqModel]>
    }
    
    init(repository : FaqRepository) {
        self.repositoryFaq = repository
    }
    
    private func makeRequestFaq(_ input: Input){
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.RequestFaq()
            }.disposed(by: self.disposeBag)
    }
    
    private func RequestFaq(){
        self.repositoryFaq
            .requestGetFaq()
            .subscribe { (result) in
                self.stateRelay.accept(.close)
                self.faqRelay.accept(result)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func transform(_ input: Input) -> Output
    {
        self.makeRequestFaq(input)
        return Output(state: self.stateRelay.asDriver().skip(1), faqOutput: self.faqRelay.asDriver().skip(1))
    }
}
