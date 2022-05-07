//
//  RegisterMemberAPI.swift
//  Altea Care
//
//  Created by Hedy on 06/09/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol RegisterMemberAPI: ClientAPI {
    func request(id: String, body: RegisterMemberBody) -> Single<RegisterMemberResponse>
}
