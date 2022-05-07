//
//  AccountRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol AccountRepository {
    
    func requestGetUserData() -> Single<AccountDataModel>
    
    func requestLogout() -> Single<LogoutModel?>
}
