//
//  InitialChangeProfileRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class InitialChangeProfileRepositoryImpl : InitialChangeProfileRepository {
    
    private let disposeBag = DisposeBag()
    private let uploadImageAPI : UploadDocumentAPI
    private let getUserDataAPI : GetUserAPI
    private let updateAvatarAPI : UpdateAvatarAPI
    
    init(uploadImageAPI : UploadDocumentAPI, getUserDataAPI : GetUserAPI, updateAvatarAPI : UpdateAvatarAPI) {
        self.getUserDataAPI = getUserDataAPI
        self.uploadImageAPI = uploadImageAPI
        self.updateAvatarAPI = updateAvatarAPI
    }
    
    func requestUpdateAvatar(body: UpdateAvatarBody) -> Single<UpdateAvatarResModel> {
        return Single.create { (observer) in
            self.updateAvatarAPI
                .requestUpdateAvatar(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, UpdateAvatarResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .updateAvatarAPI
                            .httpClient
                            .verify()
                            .andThen(self.updateAvatarAPI.requestUpdateAvatar(body: body))
                }
                    return Single.error(error)
            }
                .map {  self.outputTransformUpdateAvatar($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let status) : observer(.success(status))
                    case .failure(let error) : observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func outputTransformUpdateAvatar(_ response : UpdateAvatarResponse) -> Result<UpdateAvatarResModel, HTTPError>{
        if response.status {
            return .success(UpdateAvatarResModel(status: response.status, message: response.message))
        }
        return .failure(HTTPError.custom(response.message ))
    }
    
    func requestGetUserData() -> Single<ChangeProfileModel> {
        return Single.create { (observer) in
            self.getUserDataAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, GetUserResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .getUserDataAPI
                            .httpClient
                            .verify()
                            .andThen(self.getUserDataAPI.request())
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModelUserData($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) : observer(.success(model))
                    case .failure(let error) : observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func outputTransformModelUserData(_ response : GetUserResponse) -> Result<ChangeProfileModel, HTTPError>{
        if response.status {
            
            let model = ChangeProfileModel(
                userImage: response.data?.userDetails?.avatar?.formats?.medium ?? "",
                phoneNumber: response.data?.phone ?? "",
                email: response.data?.email ?? "",
                username: "\(response.data?.firstName ?? "") \(response.data?.lastName ?? "")",
                ageYear: response.data?.userDetails?.age?.year ?? 0,
                ageMonth: response.data?.userDetails?.age?.month ?? 0,
                birthdate: response.data?.userDetails?.birthDate ?? "",
                idCard: response.data?.userDetails?.idCard ?? "Data belum diisi",
                gender: SexFormatter.formatted("\(response.data?.userDetails?.gender ?? "")"),
                address: response.data?.userAddresses?.first?.fullAdress
                ///Need fix this address on change profile data 
            )
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func uploadImage(media: Media, boundary: String) -> Single<UploadImageModel> {
        return Single.create { (observer) in
            self.uploadImageAPI
                .request(media: media, boundary: boundary)
                .catch { (error) -> PrimitiveSequence<SingleTrait, UploadDocumentResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .uploadImageAPI
                            .httpClient
                            .verify()
                            .andThen(self.uploadImageAPI.request(media: media, boundary: boundary))
                    }
                    return Single.error(error)
                }
                .map { self.transformUploadResponse($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let status) :
                        observer(.success(status))
                    case .failure(let error) :
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func transformUploadResponse(_ response: UploadDocumentResponse) -> Result<UploadImageModel, HTTPError> {
        if response.status {
            
            return .success(UploadImageModel(status: response.status, message: response.message, id: response.data?.id))
        }
        return .failure(HTTPError.custom(response.message))
    }
}
