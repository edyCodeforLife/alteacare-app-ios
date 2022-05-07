//
//  LoginConsultationRepositoryImpl.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 22/07/21.
//

import Foundation
import RxSwift


class LoginConsultationRepositoryImpl : LoginConsulatationRepository{
    
    private let disposeBag = DisposeBag()
    private let getUserApi : GetUserAPI
    private let logoutApi : LogoutAPI
    private let loginApi: LoginAPI
    
    init(loginApi: LoginAPI, userApi: GetUserAPI, logoutApi: LogoutAPI) {
        self.loginApi = loginApi
        self.getUserApi = userApi
        self.logoutApi = logoutApi
    }
    
//    func requestLogout() -> Single<LogoutModel?> {
//        return Single.create { (observer) in
//            self.logoutApi
//                .request()
//                .catch { (error) -> PrimitiveSequence<SingleTrait, LogoutResponse> in
//                    if (error as? HTTPError) == HTTPError.expired {
//                        return self
//                            .logoutApi
//                            .httpClient
//                            .verify()
//                            .andThen(self.logoutApi.request())
//                    }
//                    return Single.error(error)
//                }
//                .map { self.transformLogoutModul($0) }
//                .subscribe(onSuccess: { (result) in
//                    switch result {
//                    case .success(let model) : observer(.success(model))
//                    case .failure(let error) : observer(.failure(error))
//                    }
//                }, onFailure: { (error) in
//                    observer(.failure(error))
//                }).disposed(by: self.disposeBag)
//            return Disposables.create()
//        }
//    }
//
//    private func transformLogoutModul(_ response : LogoutResponse) -> Result<LogoutModel?, HTTPError> {
//        if response.status {
//            let model = response.data.map { res in
//
//                return LogoutModel(status: response.status, message: response.message)
//            }
//            return .success(model)
//        }
//        return .failure(HTTPError.custom(response.message ?? ""))
//    }
    
    func requestLogin(body: LoginBody) -> Single<LoginModel> {
        return Single.create { (observer) in
            self.loginApi.request(parameters: body.dictionary ?? [String: Any]())
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, LoginResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .loginApi
                            .httpClient
                            .verify()
                            .andThen(self.loginApi.request(parameters: body.dictionary ?? [String: Any]()))
                    }
                    return Single.error(error)
                }
                .map { self.transformLoginModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) :
                        observer(.success(model))
                    case .failure(let error) :
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func transformLoginModel(_ response: LoginResponse) -> Result<LoginModel, HTTPError>{
        if let status = response.status{
            if let data = response.data, status == true{
                let loginDataResponse = LoginModel(status: response.status, message: response.message, isRegistered: data.isRegistered, isVerified: data.isVerified, accessToken: data.accessToken, refreshToken: data.refreshToken, isEmailVerified: data.isEmailVerified, isPhoneVerified: data.isPhoneVerified, deviceID: data.deviceID)
                
                //Save token using user defaults
                //                UserDefaults.standard.set(loginDataResponse.status, forKey: "status_login")
                //                Preference.set(value: loginDataResponse.accessToken, forKey: .AccessTokenKey)
                //                Preference.set(value: data.refreshToken, forKey: .AccessRefreshTokenKey)
                
                
                return .success(loginDataResponse)
            }
            return .failure(HTTPError.custom(response.message ?? ""))
        }
        return .failure(HTTPError.internalError)
    }
    
    func requestGetUserData() -> Single<UserHomeData> {
        return Single.create { (observer) in
            self.getUserApi
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, GetUserResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .getUserApi
                            .httpClient
                            .verify()
                            .andThen(self.getUserApi.request())
                    }
                    return Single.error(error)
                }
                .map { self.transformUserDataModel($0) }
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
    
    private func transformUserDataModel(_ response : GetUserResponse) -> Result<UserHomeData, HTTPError> {
        if response.status {
            if let data = response.data {
                let userData = UserHomeData(id: response.data?.id ?? "", userPhoto: data.userDetails?.avatar?.formats?.medium ?? "", ageYear: data.userDetails?.age?.year ?? 0, ageMonth: data.userDetails?.age?.month ?? 0, nameUser: "\(data.firstName ?? "") \(data.lastName ?? "")", email: data.email ?? "", dateOfBirth: data.userDetails?.birthDate ?? "", gender: data.userDetails?.gender ?? "", phone: data.phone ?? "", city: data.userAddresses?.first?.city?.name ?? "")
                
                return .success(userData)
            }
        }
        return .failure(HTTPError.custom(response.message ))
    }
    
    
}
