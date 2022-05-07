//
//  ContactUsRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class ContactUsRepositoryImpl : ContactUsRepository {
    
    private let disposeBag = DisposeBag()
    private let sendMessageAPI : SendMessageAPI
    private let getMessageTypeAPI: GetMessageTypeAPI
    private let informationCenterAPI : InformationCenterAPI
    
    //MARK: - Init API
    init(sendMessageAPI : SendMessageAPI, getMessageTypeAPI : GetMessageTypeAPI, informationCenterAPI : InformationCenterAPI) {
        self.sendMessageAPI = sendMessageAPI
        self.getMessageTypeAPI = getMessageTypeAPI
        self.informationCenterAPI =  informationCenterAPI
    }
    
    func requestSendMessage(body : SendMessageBody) -> Single<ContactUsModel?>{
        return Single.create { (observer) in
            self.sendMessageAPI.request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, SendMessageResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .sendMessageAPI
                            .httpClient
                            .verify()
                            .andThen(self.sendMessageAPI.request(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.transformResponseModelSendMessage($0) }
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
    
    private func transformResponseModelSendMessage(_ response : SendMessageResponse) -> Result<ContactUsModel, HTTPError> {
        if response.status{
            let model = ContactUsModel(status: response.status, message: response.message, data: response.data)
            
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestInformationCenter() -> Single<InformationCenterModel?> {
        return Single.create { (observer) in
            self.informationCenterAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, InformationCenterResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .informationCenterAPI
                            .httpClient
                            .verify()
                            .andThen(self.informationCenterAPI.request())
                    }
                    return Single.error(error)
                }
                .map { self.transformInformationCenter($0) }
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
    
    private func transformInformationCenter(_ response : InformationCenterResponse) -> Result<InformationCenterModel, HTTPError> {
        if response.status{
            let dataInfomationCenter = response.data.map { (data) in
                return InformationData(contentId: response.data?.contentId ?? "", title: response.data?.title ?? "", type: response.data?.type ?? "", content: ContentData(email: response.data?.content.email ?? "", phone: response.data?.content.phone ?? ""))
            }
            
            let model =  InformationCenterModel(status: response.status, message: response.message, data: dataInfomationCenter!)
            
            return.success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestSendType() -> Single<MessageTypeModel?> {
        return Single.create { (observer) in
            self.getMessageTypeAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, GetMessageTypeResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .getMessageTypeAPI
                            .httpClient
                            .verify()
                            .andThen(self.getMessageTypeAPI.request())
                    }
                    return Single.error(error)
                }
                .map { self.transformGetMessageType($0) }
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
    
    private func transformGetMessageType(_ response : GetMessageTypeResponse) -> Result<MessageTypeModel, HTTPError> {
        if response.status{
            let dataMessage = response.data.map { (data) in
                return MessageTypeData(id: data.id, name: data.name)
            }
            
            let model = MessageTypeModel(status: response.status, message: response.message, data: dataMessage)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
