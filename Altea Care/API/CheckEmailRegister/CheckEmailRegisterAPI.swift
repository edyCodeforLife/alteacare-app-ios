//
//  CheckEmailRegisterAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CheckEmailRegisterAPI : ClientAPI{
    func requestCheckEmailRegister(body : CheckEmailRegisterBody) -> Single<CheckEmailRegisterResponse>
}
