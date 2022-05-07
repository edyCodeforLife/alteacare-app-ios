//
//  RequestChangeEmailAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol RequestChangeEmailAPI: ClientAPI {
    func requestChangeEmail(body : RequestChangeEmailBody) -> Single<RequestChangeEmailResponse>
}
