//
//  ContactUsRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

protocol ContactUsRepository {
    func requestSendMessage(body : SendMessageBody) -> Single<ContactUsModel?>
    func requestSendType() -> Single<MessageTypeModel?>
    func requestInformationCenter() -> Single<InformationCenterModel?>
}
