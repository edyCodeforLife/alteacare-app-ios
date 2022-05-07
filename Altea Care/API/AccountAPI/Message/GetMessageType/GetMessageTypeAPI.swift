//
//  GetMessageTypeAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 20/06/21.
//

import Foundation
import RxSwift

protocol GetMessageTypeAPI : ClientAPI {
    func request() -> Single<GetMessageTypeResponse>
}
