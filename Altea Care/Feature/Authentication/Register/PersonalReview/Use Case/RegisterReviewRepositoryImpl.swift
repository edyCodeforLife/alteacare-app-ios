//
//  RegisterReviewRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import RxSwift

class RegisterReviewRepositoryImpl : RegisterReviewRepository{
    
    private let api : RegisterAPI
    private let disposeBag =  DisposeBag()
    
    init(api : RegisterAPI) {
        self.api = api
    }
}
