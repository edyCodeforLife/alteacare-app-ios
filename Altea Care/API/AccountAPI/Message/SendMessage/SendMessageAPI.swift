//
//  SendMessageAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 20/06/21.
//

import Foundation
import RxSwift

protocol SendMessageAPI : ClientAPI {
    func request(body: SendMessageBody) -> Single<SendMessageResponse>
}
