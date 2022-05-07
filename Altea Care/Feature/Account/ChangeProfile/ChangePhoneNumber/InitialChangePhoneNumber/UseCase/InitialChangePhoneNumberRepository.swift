//
//  InitialChangePhoneNumberRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

protocol InitialChangePhoneNumberRepository {
    func requestSendPhoneNumber(body: RequestChangePhoneNumberBody) -> Single<InitialChangePhoneNumberModel>
}
