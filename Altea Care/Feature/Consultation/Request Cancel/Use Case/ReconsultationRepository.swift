//
//  RequestCancelRepository.swift
//  Altea Care
//
//  Created by Hedy on 18/12/21.
//

import Foundation
import RxSwift

protocol RequestCancelRepository {
    func requestCancel(body: UserCancelBody) -> Completable
}

