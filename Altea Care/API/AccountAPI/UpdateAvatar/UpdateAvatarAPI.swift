//
//  UpdateAvatarAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/07/21.
//

import Foundation
import RxSwift

protocol UpdateAvatarAPI : ClientAPI {
    func requestUpdateAvatar(body : UpdateAvatarBody) -> Single<UpdateAvatarResponse>
}
