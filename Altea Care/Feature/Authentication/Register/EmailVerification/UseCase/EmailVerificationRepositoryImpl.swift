//
//  EmailVerificationRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift

class EmailVerificationRepositoryImpl : EmailVerificationRepository {
    
    private let apiVerifyEmail: VerifyEmailAPI
    private let apiSendVerification : SendVerificationEmailAPI
    private let disposeBag = DisposeBag()
    
    init(apiVerifyEmail : VerifyEmailAPI, apiSendVerification : SendVerificationEmailAPI) {
        self.apiVerifyEmail = apiVerifyEmail
        self.apiSendVerification = apiSendVerification
    }
    
    func requestNewOtp(body: SendVerificationEmailBody, type: String) -> Single<SendVerificationEmailModel> {
        return Single.create { (observer) in
            self.apiSendVerification.request(parameters: body.dictionary ?? [String : Any](), type: type)
                .catch { (error) -> PrimitiveSequence<SingleTrait, SendVerificationEmailResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .apiSendVerification
                            .httpClient
                            .verify()
                            .andThen(self.apiSendVerification.request(parameters: body.dictionary ?? [String : Any](), type: type))
                    }
                    return Single.error(error)
                }
                .map { self.getResponseVerificationEmail($0) }
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
   
    
    private func getResponseVerificationEmail(_ response : SendVerificationEmailResponse) -> Result<SendVerificationEmailModel, HTTPError> {
        if let status = response.status {
            if status == true {
                let sendVerificationEmailResponse = SendVerificationEmailModel(status: response.status ?? false, message: response.message ?? "")
                
                return .success(sendVerificationEmailResponse)
            }
            return .failure(HTTPError.custom(response.message ?? "" ))
        }
        return .failure(HTTPError.internalError)
    }
    
    func requestVerifyEmail(body: VerifyEmailBody, type: String) -> Single<EmailVerificationModel?> {
        return Single.create { (observer) in
            self.apiVerifyEmail.request(body: body.dictionary ?? [String : Any](), type: type)
                .catch { (error) -> PrimitiveSequence<SingleTrait, VerifyEmailResponse> in
                    if (error as? HTTPError) ==  HTTPError.expired {
                        return self
                            .apiVerifyEmail
                            .httpClient
                            .verify()
                            .andThen(self.apiVerifyEmail.request(body: body.dictionary ?? [String : Any](), type: type))
                    }
                    return Single.error(error)
                }
                .map { self.getResponseVerifyEmail($0) }
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
    
    private func getResponseVerifyEmail(_ response :  VerifyEmailResponse) -> Result<EmailVerificationModel?, HTTPError> {
        if let status = response.status {
            if let model = response.data, status == true {
                let verifyData = VerifyData(isRegistered: model.isRegistered, isVerified: model.isVerified, accessToken: model.accessToken, refreshToken: model.refreshToken, isEmailVerified: model.isEmailVerified, isPhoneVerified: model.isPhoneVerified, deviceId: model.deviceId)
                let verifyDataModel = EmailVerificationModel(status: response.status, message: response.message, data: verifyData)
                
                return .success(verifyDataModel)
            }
            return .failure(HTTPError.custom(response.message ?? ""))
        }
        return .failure(HTTPError.internalError)
    }
}
