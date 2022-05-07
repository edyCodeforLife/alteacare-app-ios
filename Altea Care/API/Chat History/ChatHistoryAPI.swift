//
//  ChatHistoryAPI.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

protocol ChatHistoryAPI: ClientAPI {
    func request(parameters: [String: Any]) -> Single<ChatHistoryResponse>
}
