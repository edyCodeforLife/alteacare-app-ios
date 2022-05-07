//
//  TermConditionRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 11/05/21.
//

import Foundation
import RxSwift

protocol TermConditionRepository {
    func requestTermConditionAccount() -> Single<TermConditionModel>
}
