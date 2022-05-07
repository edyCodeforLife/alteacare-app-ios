//
//  LoginRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class LoginRepositoryImpl: LoginRepository {
    
    private let sendEmailOtpApi : SendVerificationEmailAPI
    private let loginApi: LoginAPI
    private let disposeBag = DisposeBag()
    
    init(loginApi: LoginAPI, sendEmailOtpApi : SendVerificationEmailAPI) {
        self.loginApi = loginApi
        self.sendEmailOtpApi = sendEmailOtpApi
    }
    
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
                .map { self.getResponse($0) }
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
    
    private func getResponse(_ response: LoginResponse) -> Result<LoginModel, HTTPError>{
        if let status = response.status{
            if let data = response.data, status == true{
                let loginDataResponse = LoginModel(status: response.status, message: response.message, isRegistered: data.isRegistered, isVerified: data.isVerified, accessToken: data.accessToken, refreshToken: data.refreshToken, isEmailVerified: data.isEmailVerified, isPhoneVerified: data.isPhoneVerified, deviceID: data.deviceID)
                
                return .success(loginDataResponse)
            }
            return .failure(HTTPError.custom(response.message ?? ""))
        }
        return .failure(HTTPError.internalError)
    }
    
    func requestSendVerificationEmail(body: SendVerificationEmailBody, type: String) -> Single<SendVerificationEmailModel> {
        return Single.create { (observer) in
            self.sendEmailOtpApi.request(parameters: body.dictionary ?? [String : Any](), type: type)
                .catch { (error) -> PrimitiveSequence<SingleTrait, SendVerificationEmailResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .sendEmailOtpApi
                            .httpClient
                            .verify()
                            .andThen(self.sendEmailOtpApi.request(parameters: body.dictionary ?? [String : Any](), type:type))
                    }
                    return Single.error(error)
                }
                .map { self.getResponseVerify($0) }
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
    
    func getResponseVerify(_ response :  SendVerificationEmailResponse) -> Result<SendVerificationEmailModel, HTTPError> {
        if let status = response.status {
            if let data = response.data, status == true {
                let sendVerificationData = SendVerificationEmailModel(status: response.status ?? false, message: response.message ?? "")
                
                return .success(sendVerificationData)
            }
            return .failure(HTTPError.custom(response.message ?? ""))
        }
        return .failure(HTTPError.internalError)
    }
}
