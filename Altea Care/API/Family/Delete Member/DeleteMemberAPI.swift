//
//  DeleteMemberAPI.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol DeleteMemberAPI: ClientAPI {
    func request(body: DeleteMemberBody) -> Single<DeleteMemberResponse>
}
