//
//  HomeRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class HomeRepositoryImpl: HomeRepository {
    
    private let specialistApi : ListSpecialistAPI
    private let getUserDataApi : GetUserAPI
    private let listConsultationAPI: ListConsultationAPI
    private let bannerAPI : DataBannerAPI
    private let listMemberAPI: ListMemberAPI
    private let disposeBag = DisposeBag()
    private let forceUpdateAPI : ForceUpdateAPI
    private let widgetAPI: WidgetAPI
    
    init(listSpecialistAPI: ListSpecialistAPI, getUserAPI : GetUserAPI, listConsultationAPI: ListConsultationAPI, dataBannerAPI : DataBannerAPI, listMemberAPI : ListMemberAPI, forceUpdateAPI : ForceUpdateAPI, widgetAPI: WidgetAPI) {
        self.specialistApi = listSpecialistAPI
        self.getUserDataApi = getUserAPI
        self.listConsultationAPI = listConsultationAPI
        self.bannerAPI = dataBannerAPI
        self.listMemberAPI = listMemberAPI
        self.forceUpdateAPI = forceUpdateAPI
        self.widgetAPI = widgetAPI
    }
    
    func requestList() -> Single<ListMemberModel> {
        return Single.create { (observer) in
            self.listMemberAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, ListMemberResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .listMemberAPI
                            .httpClient
                            .verify()
                            .andThen(self.listMemberAPI.request())
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: ListMemberResponse) -> Result<ListMemberModel, HTTPError> {
        //MARK: - FIXME
        if response.status ?? false {
            let modelMember = response.data?.patient.map { (res) in
                return MemberModel(idMember: res.id ?? "",
                                   name: "\(res.firstName ?? "") \(res.lastName ?? "")",
                                   role: res.familyRelationType?.name ?? "",
                                   imageUser: res.cardPhoto?.formats?.medium ?? "",
                                   age: "\(res.age?.year ?? 0) Tahun \(res.age?.month ?? 0) Bulan" ,
                                   gender: res.gender ?? "",
                                   birthDate: res.birthDate ?? "",
                                   isMainProfile: res.isDefault ?? false,
                                   email : res.email,
                                   phone : res.phone
                )
                
            }
            let model = ListMemberModel(isFullyLoaded: false, model: modelMember)
            
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
    
    
    func requestBanner(category: BannerCategory) -> Single<[BannerModel]> {
        return Single.create { (observer) in
            self.bannerAPI
                .requestBanner(category: category)
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, DataBannerResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .bannerAPI
                            .httpClient
                            .verify()
                            .andThen(self.bannerAPI.requestBanner(category: category))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformBannerData($0) }
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
    
    private func outputTransformBannerData(_ response : DataBannerResponse) -> Result<[BannerModel], HTTPError> {
        if response.status {
            let model = response.data.map { (res) in
                return BannerModel(imageUrl: res.imageMobile, deeplinkUrlIos: res.deeplinkUrlIos, deeplinkIosType: res.deeplinkTypeIos)
            }
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestGetUserData() -> Single<UserHomeData> {
        return Single.create { (observer) in
            self.getUserDataApi
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, GetUserResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .getUserDataApi
                            .httpClient
                            .verify()
                            .andThen(self.getUserDataApi.request())
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformUserDataToModel($0) }
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
    
    private func outputTransformUserDataToModel(_ response : GetUserResponse) -> Result<UserHomeData, HTTPError> {
        if response.status {
            if let data = response.data {
                let userData = UserHomeData(id: response.data?.id ?? "", userPhoto: data.userDetails?.avatar?.formats?.medium ?? "", ageYear: data.userDetails?.age?.year ?? 0, ageMonth: data.userDetails?.age?.month ?? 0, nameUser: "\(data.firstName ?? "") \(data.lastName ?? "")", email: data.email ?? "", dateOfBirth: data.userDetails?.birthDate ?? "", gender: data.userDetails?.gender ?? "", phone: data.phone ?? "", city: data.userAddresses?.first?.city?.name ?? "")
                
                return .success(userData)
            }
        }
        if response.message == "jwt expired" {
            return .failure(HTTPError.expired)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestSpecialistPopular() -> Single<[ListSpecialistModel]> {
        return Single.create { (observer) in
            self.specialistApi.requestSpecialistPopular()
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, ListSpecialistResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .specialistApi
                            .httpClient
                            .verify()
                            .andThen(self.specialistApi.requestSpecialistPopular())
                    }
                    return Single.error(error)
                }
                .map { self.outputSpecialistTransformModel($0) }
                .subscribe(
                    onSuccess: { (result) in
                        switch result {
                        case .success(let model) : observer(.success(model))
                        case .failure(let error) : observer(.failure(error))
                        }
                    },
                    onFailure: { (error) in
                        observer(.failure(error))
                        
                    },
                    onDisposed: {}
                )
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
            
        }
    }
    
    private func outputSpecialistTransformModel(_ response: ListSpecialistResponse) -> Result<[ListSpecialistModel], HTTPError> {
        if response.status {
            let model = response.data.map { (res) in
                return ListSpecialistModel(specializationId: res.specializationId, name: res.name, description: res.description, isPopular: res.isPopular, iconSmall: res.icon?.formats?.small ?? "", subSpecialization: nil)
            }
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestList(body: ListConsultationBody) -> Single<OngoingConsultation> {
        return Single.create { (observer) in
            self.listConsultationAPI
                .request(parameters: body.dictionary ?? [String: Any](), type: .ongoing)
                .catch { (error) -> PrimitiveSequence<SingleTrait, ListConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .listConsultationAPI
                            .httpClient
                            .verify()
                            .andThen(self.listConsultationAPI
                                        .request(parameters: body.dictionary ?? [String: Any](), type: .ongoing))
                    }
                    return Single.error(error)
                }
                .map { self.outputOngoingConsultationTransformModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputOngoingConsultationTransformModel(_ response: ListConsultationResponse) -> Result<OngoingConsultation, HTTPError> {
        if let data = response.data, response.status {
            let model = data.map { (res) -> OngoingConsultationModel in
                var transaction: ConsultationTransactionModel? = nil
                
                if let trx = res.transaction {
                    transaction = ConsultationTransactionModel(bank: trx.bank ?? "", redirectionType: TransactionRedirectionType(rawValue: trx.type ?? "") ?? .unkown, vaNumber: trx.vaNumber, refId: trx.refId, total: trx.total, expiredAt: trx.expiredAt, paymentUrl: trx.paymentUrl)
                }
                
                return OngoingConsultationModel(id: "\(res.id ?? 0)",
                                                orderCode: res.orderCode ?? "",
                                                status: ConsultationStatus(rawValue: res.status ?? "") ?? .unknown,
                                                statusDetail: res.statusDetail?.label ?? "",
                                                statusBgColor: UIColor(hexString: res.statusDetail?.bgColor ?? ""),
                                                statusTextColor: UIColor(hexString: res.statusDetail?.textColor ?? ""),
                                                hospitalName: res.doctor?.hospital.name ?? "",
                                                doctorName: res.doctor?.name ?? "",
                                                specialty: "\(res.doctor?.specialist.name ?? "")",
                                                date: res.schedule?.date.dateFormattedUS(),
                                                time: "\(res.schedule?.timeStart ?? "") - \(res.schedule?.timeEnd ?? "")",
                                                startTime: res.schedule?.timeStart ?? "",
                                                hospitalIcon: res.doctor?.hospital.logo ?? "",
                                                doctorImage: res.doctor?.photo?.url ?? "",
                                                transaction: transaction,
                                                dateSchedule: res.schedule?.date ?? "",
                                                patientFamilyMember: res.patient)
            }
            let result = OngoingConsultation(isFullyLoaded: response.meta.page == response.meta.totalPage || model.isEmpty, model: model)
            return .success(result)
        } else if !response.status && ((response.data?.isEmpty) != nil) {
            let result = OngoingConsultation(isFullyLoaded: true, model: [])
            return .success(result)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestForceUpdate() -> Single<ForceUpdateModel> {
        return Single.create { (observer) in
            self.forceUpdateAPI
                .requestForceUpdate()
                .catch { (error) -> PrimitiveSequence<SingleTrait, ForceUpdateResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .forceUpdateAPI
                            .httpClient
                            .verify()
                            .andThen(self.forceUpdateAPI.requestForceUpdate())
                    }
                    return Single.error(error)
                }
                .map { self.outputTranforModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTranforModel(_ response : ForceUpdateResponse) -> Result<ForceUpdateModel, HTTPError> {
        if response.status ?? false {
            let data = ForceUpdateModel(isUpdateRequired: response.data?.isUpdateRequired)
            
            return .success(data)
        }
        return .failure(HTTPError.custom(response.message ))
    }
    
    func requestWidgets() -> Single<[WidgetModel]> {
        return Single.create { (observer) in
            self.widgetAPI
                .getWidgets()
                .catch { (error) -> PrimitiveSequence<SingleTrait, WidgetResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .widgetAPI
                            .httpClient
                            .verify()
                            .andThen(self.widgetAPI.getWidgets())
                    }
                    return Single.error(error)
                }
                .map { self.outputTranforModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    print("errornya",error)
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTranforModel(_ response : WidgetResponse) -> Result<[WidgetModel], HTTPError> {
        if response.status {
            let model = response.data.sorted(by: { $0.weight > $1.weight }).map { (res) in
                return WidgetModel(title: res.title, imageUrl: res.ios.icon.url ?? "", deeplinkType: (res.ios.deeplinkType == "WEB") ? .web : .deepLink, deeplinkUrl: res.ios.deeplinkUrl, needLogin: res.needLogin)
            }
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ))
    }
}
