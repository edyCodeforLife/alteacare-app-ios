//
//  InitialChangeProfileRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

protocol InitialChangeProfileRepository {
    func requestGetUserData() -> Single<ChangeProfileModel>
    func uploadImage(media : Media, boundary : String) -> Single<UploadImageModel>
    func requestUpdateAvatar(body : UpdateAvatarBody) -> Single<UpdateAvatarResModel>
}
