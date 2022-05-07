//
//  ReverificationEmailRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift

class ReverificationEmailRepositoryImpl : ReverificationEmailRepository {
   
    private let verifyEmailForgotPasswordAPI : VerifyOtpFPApi
    private let requestNewOtpForgotPasswordAPI : RequestForgotPasswordAPI
    private let disposeBag = DisposeBag()
    
    init(verifyEmailForgotPasswordAPI : VerifyOtpFPApi, requestNewOtpForgotPasswordAPI : RequestForgotPasswordAPI) {
        self.verifyEmailForgotPasswordAPI = verifyEmailForgotPasswordAPI
        self.requestNewOtpForgotPasswordAPI = requestNewOtpForgotPasswordAPI
    }
    
    func requestNewOtpChangePassword(body: RequestForgotPasswordBody) -> Single<ForgotPasswordModel> {
        return Single.create { (observer) in
            self.requestNewOtpForgotPasswordAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, RequestForgotPasswordResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .requestNewOtpForgotPasswordAPI
                            .httpClient
                            .verify()
                            .andThen(self.requestNewOtpForgotPasswordAPI.request(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.tranformRequestNewOTP($0) }
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
    
    func tranformRequestNewOTP(_ response : RequestForgotPasswordResponse) -> Result<ForgotPasswordModel, HTTPError>{
        if let status = response.status {
            if status == true {
                return .success(ForgotPasswordModel(status: response.status ?? false, message: response.message))
            }
            return .failure(HTTPError.custom(response.message))
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestVerifyForgotPassword(body: VerifyOTPForgotPasswordBody) -> Single<ReverificationEmailModel> {
        return Single.create { (observer) in
            self.verifyEmailForgotPasswordAPI
                .request(parameters: body.dictionary ?? [String:Any]())
                .catch { (error) -> PrimitiveSequence<SingleTrait, VerifyOtpFPResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .verifyEmailForgotPasswordAPI
                            .httpClient
                            .verify()
                            .andThen(self.verifyEmailForgotPasswordAPI.request(parameters: body.dictionary ?? [String:Any]()))
                    }
                    return Single.error(error)
                }
                .map { self.transformVerificationForgotPassowrd($0)}
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model): observer(.success(model))
                    case .failure(let error): observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func transformVerificationForgotPassowrd(_ response : VerifyOtpFPResponse) -> Result<ReverificationEmailModel, HTTPError>{
        if let status = response.status {
            if status == true {
                return .success(ReverificationEmailModel(status: response.status ?? false, message: response.message, data: VerifyData(isRegistered: response.data?.isRegistered ?? false, isVerified: response.data?.isVerified ?? false, accessToken: response.data?.accessToken ?? "", refreshToken: response.data?.refreshToken ?? "", isEmailVerified: response.data?.isEmailVerified ?? false, isPhoneVerified: response.data?.isPhoneVerified ?? false, deviceId: response.data?.deviceId ?? "")))
            }
            return .failure(HTTPError.custom(response.message))
        }
        return .failure(HTTPError.custom(response.message))
    }
}
