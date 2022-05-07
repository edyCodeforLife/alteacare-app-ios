//
//  AddMemberAPI.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddMemberAPI: ClientAPI {
    func request(body: AddMemberBody) -> Single<AddMemberResponse>
}
