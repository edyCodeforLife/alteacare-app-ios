//
//  CreatePasswordRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import RxSwift

class CreatePasswordImpl : CreatePasswordRepository {
    private let api : RegisterAPI
    private let disposeBag = DisposeBag()
    
    init(api: RegisterAPI) {
        self.api = api
    }
}
