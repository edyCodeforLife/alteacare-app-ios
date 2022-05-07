//
//  TermAndConditionRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class TermAndConditionRepositoryImpl : TermAndConditionRepository {
    
    private let apiRegister : RegisterAPI
    private let sendEmailOtpApi : SendVerificationEmailAPI
    private let termConditionApi : TermConditionAPI
    private let disposeBag = DisposeBag()
    
    init(apiRegister : RegisterAPI, sendEmailOtp : SendVerificationEmailAPI, termConditionAPI: TermConditionAPI) {
        self.apiRegister = apiRegister
        self.sendEmailOtpApi = sendEmailOtp
        self.termConditionApi = termConditionAPI
    }
    
    func requestTermCondition() -> Single<TermAndConditionModel> {
        return Single.create { (observer) in
            self.termConditionApi
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, TermConditionResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .termConditionApi
                            .httpClient
                            .verify()
                            .andThen(self.termConditionApi.request())
                    }
                    return Single.error(error)
                }
                .map { self.responseTransformTermCondition($0)
                }
                .subscribe(onSuccess: { (result) in
                    switch result{
                    case .success(let model) : observer(.success(model))
                    case .failure(let error) : observer(.failure(error))
                    }
                    
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func responseTransformTermCondition(_ response : TermConditionResponse) -> Result<TermAndConditionModel, HTTPError> {
        if response.status{
            let termConditionData = response.data.map { (res) in
                return TermAndConditionModel(text: res.text)
                //return TermConditionModel(text: res.text)
            }!
            return .success(termConditionData)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestRegister(body: RegisterBody) -> Single<RegisterModel?> {
        return Single.create { (observer) in
            self.apiRegister.request(body: body.dictionary ?? [String : Any]())
                .catch{ (error) -> PrimitiveSequence<SingleTrait, RegisterResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .apiRegister
                            .httpClient
                            .verify()
                            .andThen(self.apiRegister.request(body: body.dictionary ?? [String:Any]()))
                    }
                    return Single.error(error)
                }
                .map {
                    self.getResponse($0) }
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
    
    private func getResponse(_ response : RegisterResponse) -> Result<RegisterModel, HTTPError> {
        if let status = response.status{
            if let data = response.data, status == true {
                
                let dataRegister =  RegisterModelData(isRegistered: data.isRegistered, isVerified: data.isVerified, accessToken: data.accessToken, refreshToken: data.refreshToken, isEmailVerified: data.isEmailVerified, isPhoneVerified: data.isPhoneVerified, deviceId: data.deviceId)
                
                let registerDataResponse = RegisterModel(status: response.status, message: response.message, data: dataRegister)
                
                return .success(registerDataResponse)
            }
            return .failure(HTTPError.custom(response.message))
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestSendVerificationEmail(body: SendVerificationEmailBody) -> Single<SendVerificationEmailModel> {
        return Single.create { (observer) in
            self.sendEmailOtpApi.request(parameters: body.dictionary ?? [String : Any](), type: "phone")
                .catch { (error) -> PrimitiveSequence<SingleTrait, SendVerificationEmailResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .sendEmailOtpApi
                            .httpClient
                            .verify()
                            .andThen(self.sendEmailOtpApi.request(parameters: body.dictionary ?? [String : Any](), type: "phone"))
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
